//
//  SidebarView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

var applicationScreenWindow: UIWindow?
let deviceScreenWidth: CGFloat = UIScreen.main.bounds.width
let deviceScreenHeight: CGFloat = UIScreen.main.bounds.height
let statusbarFrame: CGRect = UIApplication.shared.statusBarFrame

import UIKit

public class SidebarView: NSObject {
    
    // MARK: - Variables and Delegate
    
    private weak var screenWindow: UIWindow?
    private weak var rootViewController: UIViewController?
    
    public private(set) var sidebarViewIsShowing: Bool = false
    
    public private(set) var dismissesOnSelection: Bool = true
    public private(set) var shouldPushOnDisplay: Bool = false
    public private(set) var roundedCornerRadius: CGFloat?
    
    public private(set) var containsHeaders: Bool!
    public private(set) var percentageOfScreen: CGFloat = 0.80
    public private(set) var sidebarViewBlurColor: UIColor = UIColor(white: 0.0, alpha: 0.5)
    
    
    
    private var backgroundBlurEffect: UIBlurEffect = UIBlurEffect(style: .dark)
    private var backgroundBlurEffectView: UIVisualEffectView!
    
    private var sidebarViewBackgroundColor: UIColor = UIColor.white
    private var sidebarCellBackgroundColor: UIColor = UIColor.white
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        gesture.delegate = self
        return gesture
    }()
    
    private weak var delegate: SidebarViewDelegate?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - UI Elements
    
    public private(set) lazy var backgroundBlurView: UIView = {
        var frame: CGRect = CGRect.zero
        if let window = UIApplication.shared.keyWindow {
            frame = window.frame
        }
        
        let view = UIView(frame: frame)
        view.backgroundColor = self.sidebarViewBlurColor
        view.isUserInteractionEnabled = true
        view.alpha = 0.0
        return view
    }()
    
    private let sidebarHeaderReuseIdentifier = "sidebareHeaderView"
    private let sidebarReuseIdentifier = "sidebarCell"
    
    private lazy var sidebarCollectionView: SidebarCollectionView = {
        var frame: CGRect = CGRect.zero
        if let window = UIApplication.shared.keyWindow {
            frame = CGRect(x: -(window.frame.width * self.percentageOfScreen),
                           y: 0,
                           width: (deviceScreenWidth * self.percentageOfScreen),
                           height: window.frame.height)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: (deviceScreenWidth * self.percentageOfScreen), height: 60)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionview = SidebarCollectionView(frame: frame, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor.white
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Initializers
    
    @available(*, unavailable, message: "This initializer has been deprecated. Use initializers with optional delegate argument instead.")
    public override init() {
        super.init()
        
        addSubviewsToWindow()
    }
    
    public init(delegate: SidebarViewDelegate?) {
        super.init()
        
        setupProperties(with: delegate)
        // Add as a subview to window and set delegate and datasource
        addSubviewsToWindow()
    }
    
    public init(delegate: SidebarViewDelegate?, dismissesOnSelection: Bool) {
        super.init()

        setupProperties(with: delegate)
        // Add as a subview to window and set delegate and datasource
        addSubviewsToWindow()

        self.dismissesOnSelection = dismissesOnSelection

    }

    public init(delegate: SidebarViewDelegate?, dismissesOnSelection: Bool, pushesRootOnDisplay: Bool) {
        super.init()

        setupProperties(with: delegate)
        // Add as a subview to window and set delegate and datasource
        addSubviewsToWindow()

        self.dismissesOnSelection = dismissesOnSelection

        self.shouldPushOnDisplay = pushesRootOnDisplay

    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Functions
    
    private func setupProperties(with delegate: SidebarViewDelegate?) {
        self.delegate = delegate
        
        if let registedCell = delegate?.registerCustomCellForSidebarView {
            let cellClass: AnyClass = registedCell() as AnyClass
            // Use a custom cell
            setupSidebarCollectionView(withCell: cellClass.self, andHeaderView: SidebarHeaderView.self)
        } else {
            // use the default
            setupSidebarCollectionView(withCell: SidebarViewCell.self, andHeaderView: SidebarHeaderView.self)
        }
        
        // Set custom width IF the user provides one. Otherwise use default 0.8 (80 %)
        if let customSidebarViewWidth = delegate?.sidebarViewWidth {
            self.percentageOfScreen = customSidebarViewWidth
        }
        
        // Set custom background color for the SidebarView if user provides it
        if let customBackgroundColor = delegate?.sidebarViewBackgroundColor {
            self.sidebarViewBackgroundColor = customBackgroundColor
            self.sidebarCollectionView.backgroundColor = self.sidebarViewBackgroundColor
        }
        
        // Set custom background color of the underlying "blur" view
        if let blurBackgroundColor = delegate?.backgroundColor {
            self.sidebarViewBlurColor = blurBackgroundColor
        }
        
        // Set .dark, .light or .extraLight style for UIBlurEffectStyle if user provides it
        if let blurEffectStyle = delegate?.blurBackgroundStyle {
            self.backgroundBlurEffect = UIBlurEffect(style: blurEffectStyle)
            self.initializeBackgroundBlurView(withBlurEffect: self.backgroundBlurEffect)
        }
        
        // If set, this will push the rootViewController's view when the SidebarView is displayed
        if let willPushOnDisplay = delegate?.shouldPushRootViewControllerOnDisplay {
            shouldPushOnDisplay = willPushOnDisplay
        }
        
        // ** If set, this will round the topRight and bottomRight corners of the SidebarView
        // ** WARNING: If the SidebarView contains too many options that would require scrolling
        //              to see the last cells, the roundedCorner will cut them off.
        if let getRoundedRadius = delegate?.shouldRoundCornersWithRadius {
            roundedCornerRadius = getRoundedRadius()
            self.sidebarCollectionView.roundCorners(corners: [.topRight, .bottomRight], radius: getRoundedRadius())
        }
        
        // Determine if swiping the screen will also display the sidebarview
        if let allowsPullToDisplay = delegate?.allowsPullToDisplay, let window = UIApplication.shared.keyWindow {
            //allowsPullToDisplay ? window.rootViewController?.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))) : nil
            allowsPullToDisplay ? window.visibleViewController()?.view.addGestureRecognizer(panGesture) : nil
        }
        
        
        
        
        
        // TODO: Figure this out...
        if let willDisplayHeaders = delegate?.willDisplayHeaders {
            self.containsHeaders = willDisplayHeaders()
            
            /*
             print("contains headers: \(self.containsHeaders)")
             
             if self.containsHeaders {
             collectionView.register(SidebarHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sidebarHeaderReuseIdentifier)
             }
             */
        }
        
        
        
        
        // backgroundColor of sidebarViewCell
        if let cellBackgroundColor = delegate?.sidebarCellBackgroundColor {
            self.sidebarCellBackgroundColor = cellBackgroundColor
        }
    }
    
    private func addSubviewsToWindow() {
        if let window = UIApplication.shared.keyWindow {
            screenWindow = window
            self.backgroundBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SidebarView.dismiss)))
            
            //window.visibleViewController()?.view.addSubview(SidebarView.backgroundBlurView)
            //window.visibleViewController()?.view.addSubview(SidebarView.sidebarCollectionView)
            window.addSubview(self.backgroundBlurView)
            window.addSubview(self.sidebarCollectionView)
        }
    }
    
    private func setupSidebarCollectionView(withCell customCell: AnyClass, andHeaderView customHeaderView: AnyClass) {
        self.sidebarCollectionView.register(customCell, forCellWithReuseIdentifier: self.sidebarReuseIdentifier)
        self.sidebarCollectionView.register(customHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.sidebarHeaderReuseIdentifier)
    }
    
    private func initializeBackgroundBlurView(withBlurEffect blurEffect: UIBlurEffect?) {
        // Chcek if user provided a blur effect. If not, do nothing
        if blurEffect != nil {
            backgroundBlurEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundBlurEffectView.frame = backgroundBlurView.bounds
            backgroundBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundBlurView.addSubview(backgroundBlurEffectView)
        }
    }
    
    @available(*, unavailable, renamed: "show")
    public func showSidebarView() {
        performAnimationToDisplaySidebarView()
    }
    
    public func show() {
        performAnimationToDisplaySidebarView()
    }
    
    private func performAnimationToDisplaySidebarView() {
        
        // Unintentionally cuts off the entire UICollectionView. Meaning if the number of cells required scrolling, rounding the corners
        // would make the bottom-most cells invisible
        if let radius = roundedCornerRadius {
            self.sidebarCollectionView.roundCorners(corners: [.topRight, .bottomRight], radius: radius)
        }
        
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        
        // View animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.backgroundBlurView.alpha = 1.0
            self.sidebarCollectionView.frame = CGRect(x: 0,
                                                             y: 0,
                                                             width: (deviceScreenWidth * self.percentageOfScreen),
                                                             height: (self.screenWindow?.frame.height)!)
            if self.shouldPushOnDisplay == true {
                
                self.screenWindow?.visibleViewController()?.view.frame = CGRect(x: deviceScreenWidth * self.percentageOfScreen,
                                                                                y: 0,
                                                                                width: deviceScreenWidth,
                                                                                height: deviceScreenHeight)
                
            }
            
            
        }, completion: { (completed) in
            if completed {
                self.sidebarViewIsShowing = true
            }
        })
        
        CATransaction.commit()
    }
    
    @objc public func dismiss() {
        
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        
        // View animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.backgroundBlurView.alpha = 0.0
            
            self.sidebarCollectionView.frame = CGRect(x: -((self.screenWindow?.frame.width)! * self.percentageOfScreen),
                                                             y: 0,
                                                             width: deviceScreenWidth * self.percentageOfScreen,
                                                             height: (self.screenWindow?.frame.height)!)
            if self.shouldPushOnDisplay == true {
                //self.screenWindow?.rootViewController?.view.frame = CGRect(x: 0, y: 0, width: deviceScreenWidth, height: deviceScreenHeight)
                self.screenWindow?.visibleViewController()?.view.frame = CGRect(x: 0, y: 0, width: deviceScreenWidth, height: deviceScreenHeight)
            }
            
        }) { (completed) in
            
            self.sidebarViewIsShowing = false
            
        }
        
        CATransaction.commit()
    }
    
    private var sidebarViewOrigin: CGPoint = CGPoint.zero
    
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        // Keep users from swiping even though the SidebarView is already showing
        guard sidebarViewIsShowing == false else { return }
        
        if let window = UIApplication.shared.keyWindow, let rootView = window.rootViewController?.view {
            
            let translation = panGesture.translation(in: rootView)
            
            
            if panGesture.state == .began {
                
                // Store old origin
                
                sidebarViewOrigin = self.sidebarCollectionView.frame.origin
                
            } else if panGesture.state == .ended || panGesture.state == .failed || panGesture.state == .cancelled {
                
                if translation.x >= rootView.frame.width * 0.35 {
                    show()
                } else {
                    dismiss()
                }
                
            } else {
                
                if translation.x >= rootView.frame.width * 0.35 {
                    show()
                } else {
                    let newOrigin: CGPoint = CGPoint(x: sidebarViewOrigin.x + (translation.x * 1.5),
                                                     y: sidebarViewOrigin.y)
                    
                    self.sidebarCollectionView.frame.origin = newOrigin
                    
                    let percentTo35: CGFloat = (translation.x) / (rootView.frame.width * 0.35)
                    self.backgroundBlurView.alpha = percentTo35
                }
            }
        }
        
    }
}













extension SidebarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView delegate and datasource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.numberOfSections(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.sidebarView(self, numberOfItemsInSection: section) ?? 0
    }
    
    
    
    
    // Configure header
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header: SidebarHeaderView?
            
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sidebarHeaderReuseIdentifier, for: indexPath) as? SidebarHeaderView
            
            
            
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
        
        if self.containsHeaders == true {
            if let del = delegate, let height = del.sidebarView?(self, heightForHeaderIn: section) {
                
                //print("height: \(height)")
                return CGSize(width: (deviceScreenWidth * self.percentageOfScreen), height: height)
            }
        }
        // Default
        return CGSize(width: (deviceScreenWidth * self.percentageOfScreen), height: 0)
        
    }
    
    
    
    
    
    
    // Configure Cell
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let del = delegate, let height = del.sidebarView?(heightForItemIn: indexPath.section) {
            return CGSize(width: (deviceScreenWidth * self.percentageOfScreen), height: height)
        }
        return CGSize(width: (deviceScreenWidth * self.percentageOfScreen), height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Use default SidebarViewCell
        
        let items = delegate?.sidebarView(titlesForItemsIn: indexPath.section)
        print("items: \(items!)")
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sidebarReuseIdentifier, for: indexPath) as? SidebarViewCell {
            
            configureCell(cell, forIndexPath: indexPath)
            
            return cell
            
        } else {
            
            // Use custom cell that user passes in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sidebarReuseIdentifier, for: indexPath)
            
            configureCustomCell(cell, forIndexPath: indexPath)
            
            return cell
            
        }
    }
    
    private func configureCell(_ cell: SidebarViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.backgroundColor = self.sidebarCellBackgroundColor
        
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
        
        cell.backgroundColor = self.sidebarCellBackgroundColor
        
        delegate?.sidebarView?(configureCell: cell, forItemAt: indexPath)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sidebarView?(self, didSelectItemAt: indexPath)
        
        // Whenever an item is clicked, dismiss the sidebar anyway
        dismiss()
        
        // This will keep the sidebarView on screen even though a new controller was pushed. Figure this out...
        // dismissesOnSelection ? dismiss() : nil
    }
    
}







extension SidebarView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let window = screenWindow, let controllerView = window.visibleViewController()?.view else { return false }
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: controllerView)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
    
}
