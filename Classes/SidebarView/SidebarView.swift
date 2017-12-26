//
//  SidebarView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

let deviceScreenWidth: CGFloat = UIScreen.main.bounds.width
let deviceScreenHeight: CGFloat = UIScreen.main.bounds.height
let statusbarFrame: CGRect = UIApplication.shared.statusBarFrame

import UIKit

public class SidebarView: NSObject {
    
    private var screenWindow: UIWindow?
    
    //public var dismissesOnSelection: Bool = true
    
    
    public static var containsHeaders: Bool!
    public static var percentageOfScreen: CGFloat = 0.80
    public static var sidebarViewBlurColor: UIColor = UIColor(white: 0.0, alpha: 0.5)
    
    private static var backgroundBlurEffect: UIBlurEffect = UIBlurEffect(style: .dark)
    private static var backgroundBlurEffectView: UIVisualEffectView!
    
    public static var sidebarViewBackgroundColor: UIColor = UIColor.white
    public static var sidebarCellBackgroundColor: UIColor = UIColor.white
    
    public weak var delegate: SidebarViewDelegate? {
        didSet {
            
            if let registedCell = delegate?.registerCustomCellForSidebarView {
                // Unfortunately, there is no way to silence this warning at the moment
                let cellClass: AnyClass = registedCell() as AnyClass
                // Use a custom cell
                initializeSidebarViewCollectionView(withCell: cellClass.self, andHeaderView: SidebarHeaderView.self)
            } else {
                // use the default
                initializeSidebarViewCollectionView(withCell: SidebarViewCell.self, andHeaderView: SidebarHeaderView.self)
            }
            
            // If user chooses a custom width with the "sidebarViewWidth" delegate function
            if let customSidebarViewWidth = delegate?.sidebarViewWidth {
                SidebarView.percentageOfScreen = customSidebarViewWidth
            }
            
            // background of sidebarview
            if let customBackgroundColor = delegate?.sidebarViewBackgroundColor {
                SidebarView.sidebarViewBackgroundColor = customBackgroundColor
                SidebarView.sidebarCollectionView.backgroundColor = SidebarView.sidebarViewBackgroundColor
            }
            
            // background of the underlying "blur" view
            if let blurBackgroundColor = delegate?.backgroundColor {
                SidebarView.sidebarViewBlurColor = blurBackgroundColor
            }
            
            // dark or light style for UIBlurEffectStyle
            if let blurEffectStyle = delegate?.blurBackgroundStyle {
                SidebarView.backgroundBlurEffect = UIBlurEffect(style: blurEffectStyle)
                SidebarView.initializeBackgroundBlurView(withBlurEffect: SidebarView.backgroundBlurEffect)
            }
            
            // backgroundColor of sidebarViewCell
            if let cellBackgroundColor = delegate?.sidebarCellBackgroundColor {
                SidebarView.sidebarCellBackgroundColor = cellBackgroundColor
            }
            
            // TODO: Figure this out...
            if let willDisplayHeaders = delegate?.willDisplayHeaders {
                SidebarView.containsHeaders = willDisplayHeaders()
                
                /*
                 print("contains headers: \(self.containsHeaders)")
                 
                 if self.containsHeaders {
                 collectionView.register(SidebarHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sidebarHeaderReuseIdentifier)
                 }
                 */
            }
        }
    }
    
    fileprivate static let sidebarHeaderReuseIdentifier = "sidebareHeaderView"
    fileprivate static let sidebarReuseIdentifier = "sidebarCell"
    
    // MARK: - UI Elements
    
    public static var backgroundBlurView: UIView!
    
    //fileprivate lazy var collectionView: UICollectionView = {
    fileprivate static var sidebarCollectionView: SidebarCollectionView = {
        let collectionview = SidebarCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor.white
        return collectionview
    }()
    
    fileprivate static var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: (deviceScreenWidth * percentageOfScreen), height: 60)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        return layout
    }()
    
    
    
    
    
    
    
    
    public override init() {
        super.init()
        
    }
    
    public init(dismissesOnSelection: Bool) {
        super.init()
    }
    
    private func initializeSidebarViewCollectionView(withCell customCell: AnyClass, andHeaderView customHeaderView: AnyClass) {
        
        SidebarView.sidebarCollectionView.delegate = self
        SidebarView.sidebarCollectionView.dataSource = self
        
        SidebarView.sidebarCollectionView.register(customCell, forCellWithReuseIdentifier: SidebarView.sidebarReuseIdentifier)
        SidebarView.sidebarCollectionView.register(customHeaderView, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SidebarView.sidebarHeaderReuseIdentifier)
    }
    
    private class func initializeBackgroundBlurView(withBlurEffect blurEffect: UIBlurEffect) {
        if backgroundBlurView == nil {
            backgroundBlurView = UIView()
            backgroundBlurEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundBlurEffectView.frame = backgroundBlurView.bounds
            backgroundBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //backgroundBlurView.addSubview(backgroundBlurEffectView)
        }
    }
    
    public func showSidebarView() {
        if let window = UIApplication.shared.keyWindow {
            //if let window = screenWindow {
            
            ///*
            window.backgroundColor = .white
            //window.backgroundColor = window.rootViewController?.view.backgroundColor
            
            SidebarView.backgroundBlurView.backgroundColor = SidebarView.sidebarViewBlurColor
            SidebarView.backgroundBlurView.isUserInteractionEnabled = true
            //SidebarView.backgroundBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            SidebarView.backgroundBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SidebarView.dismiss)))
            
            window.addSubview(SidebarView.backgroundBlurView)
            window.addSubview(SidebarView.sidebarCollectionView)
            
            SidebarView.backgroundBlurView.frame = window.frame
            SidebarView.backgroundBlurView.alpha = 0.0
            
            
            SidebarView.sidebarCollectionView.frame = CGRect(x: -window.frame.width, y: 0, width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: window.frame.height)
            
            
            
            // Unintentionally cuts off the entire UICollectionView. Meaning if the number of cells required scrolling, rounding the corners
            // would make the bottom-most cells invisible
            SidebarView.sidebarCollectionView.roundCorners(corners: [.topRight, .bottomRight], radius: 30)
            
            //*/
            
            /* Do Animations */
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            
            // View animations
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                SidebarView.backgroundBlurView.alpha = 1.0
                SidebarView.sidebarCollectionView.frame = CGRect(x: 0, y: 0, width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: window.frame.height)
                window.rootViewController?.view.frame = CGRect(x: deviceScreenWidth * SidebarView.percentageOfScreen, y: 0, width: deviceScreenWidth, height: deviceScreenHeight)
                
                
            }, completion: nil)
            
            CATransaction.commit()
        }
    }
    
    @objc public func dismiss() {
        
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        
        // View animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow {
                SidebarView.backgroundBlurView.alpha = 0.0
                
                SidebarView.sidebarCollectionView.frame = CGRect(x: -window.frame.width, y: 0, width: deviceScreenWidth * SidebarView.percentageOfScreen, height: window.frame.height)
                window.rootViewController?.view.frame = CGRect(x: 0, y: 0, width: deviceScreenWidth, height: deviceScreenHeight)
            }
            
        }) { (completed) in
            
            //print("dismiss animation complete?: \(completed)")
            
            SidebarView.backgroundBlurView.removeFromSuperview()
            SidebarView.sidebarCollectionView.removeFromSuperview()
            
        }
        
        CATransaction.commit()
    }
    
    
    
    
    
}

extension SidebarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView delegate and datasource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let del = delegate {
            return del.numberOfSections(in: self)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let del = delegate {
            return del.sidebarView(self, numberOfItemsInSection: section)
        }
        return 0
    }
    
    
    
    
    // Configure header
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header: SidebarHeaderView?
            
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SidebarView.sidebarHeaderReuseIdentifier, for: indexPath) as? SidebarHeaderView
            
            
            
            if let del = delegate, let customHeaderView = del.sidebarView?(self, viewForHeaderIn: indexPath.section) {
                
                header?.addSubview(customHeaderView)
                
                customHeaderView.frame = CGRect(x: 0, y: 0, width: (header?.frame.width)!, height: (header?.frame.height)!)
                
            } else {
                print("no custom header. find way to use a default view")
            }
            
            return header!
        default:
            fatalError("Unexpected element kind")
        }
        
        /*
         This should be unnecessary because if containsHeaders == false, this function will not be called as no UICollectionReusableView was registered
         if containsHeaders == true {
         
         } else {
         fatalError("No header was registered")
         }
         */
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if SidebarView.containsHeaders == true {
            if let del = delegate, let height = del.sidebarView?(self, heightForHeaderIn: section) {
                
                //print("height: \(height)")
                return CGSize(width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: height)
            }
        }
        // Default
        return CGSize(width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: 0)
        
    }
    
    
    
    
    
    
    // Configure Cell
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let del = delegate, let height = del.sidebarView?(heightForItemIn: indexPath.section) {
            return CGSize(width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: height)
        }
        return CGSize(width: (deviceScreenWidth * SidebarView.percentageOfScreen), height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Use default SidebarViewCell
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SidebarView.sidebarReuseIdentifier, for: indexPath) as? SidebarViewCell {
            
            configureCell(cell, forIndexPath: indexPath)
            
            return cell
            
        } else {
            
            // Use custom cell that user passes in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SidebarView.sidebarReuseIdentifier, for: indexPath)
            
            configureCustomCell(cell, forIndexPath: indexPath)
            
            return cell
            
        }
    }
    
    private func configureCell(_ cell: SidebarViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.backgroundColor = SidebarView.sidebarCellBackgroundColor
        
        if let del = delegate {
            
            let titles = del.sidebarView(titlesForItemsIn: indexPath.section)
            cell.optionLabel.text = titles[indexPath.item]
            
            if let textColor = del.sidebarView?(textColorForTitleAt: indexPath) {
                cell.optionLabel.textColor = textColor
            }
            
            if let font = del.sidebarView?(fontForTitleAt: indexPath) {
                cell.optionLabel.font = font
            }
            
        }
        
    }
    
    private func configureCustomCell(_ cell: UICollectionViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.backgroundColor = SidebarView.sidebarCellBackgroundColor
        
        if let del = delegate {
            if let customCellConfiguration = del.sidebarView?(configureCell: cell, forItemAt: indexPath) {
                customCellConfiguration
            }
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate, let callFunction = del.sidebarView?(self, didSelectItemAt: indexPath) {
            callFunction
        }
        
        // Whenever an item is clicked, dismiss the sidebar anyway
        dismiss()
        
        // This will keep the sidebarView on screen even though a new controller was pushed. Figure this out...
        // dismissesOnSelection ? dismiss() : nil
    }
    
}
