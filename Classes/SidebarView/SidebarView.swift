//
//  SidebarView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

import UIKit

public class SidebarView: NSObject {
    
    // MARK: - Variables and Delegate
    
    public private(set) var sidebarViewIsShowing: Bool = false
    
    public var dismissesOnSelection: Bool = true
    public var shouldPushRootControllerOnDisplay: Bool = false
    
    public var allowsPullToDisplay: Bool = false {
        didSet {
            if allowsPullToDisplay == true && applicationScreenWindow?.gestureRecognizers?.contains(panGesture) == false {
                applicationScreenWindow?.visibleViewController()?.view.addGestureRecognizer(panGesture)
            } else if allowsPullToDisplay == false {
                applicationScreenWindow?.visibleViewController()?.view.removeGestureRecognizer(panGesture)
            }
        }
    }
    
    public var dimmedBackgroundColor: UIColor = Constants.Colors.defaultDimmedViewBackground {
        didSet {
            self.backgroundBlurView.backgroundColor = dimmedBackgroundColor
        }
    }
    
    public var sidebarCornerRadius: CGFloat = 0 {
        didSet {
            self.sidebarContainerView.prepareToRound(corners: [.topRight, .bottomRight], withRadius: sidebarCornerRadius)
        }
    }
    
    private var backgroundBlurEffectView: UIVisualEffectView?
    public var blurBackgroundEffect: UIBlurEffect? {
        didSet {
            self.initializeBackgroundBlurView(withBlurEffect: blurBackgroundEffect)
        }
    }
    
    public var sidebarBackgroundColor: UIColor = Constants.Colors.defaultSidebarCollectionViewBackground {
        didSet {
            sidebarCollectionView.backgroundColor = sidebarBackgroundColor
        }
    }
    
    public var sidebarViewScreenPercentageWidth: CGFloat = Constants.Dimensions.defaultScreenWidthPercentage {
        didSet {
            guard
                sidebarViewScreenPercentageWidth > 0 &&
                sidebarViewScreenPercentageWidth <= 1.0
            else {
                fatalError("The width of the SidebarView as a percentage must not be 0 and must be less than or equal to 1")
            }
            sidebarContainerViewWidthAnchor?.constant = sidebarViewWidthConstant
            containerView.layoutIfNeeded()
            sidebarCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    
    
    
    private var sidebarViewWidthConstant: CGFloat {
        let sidebarViewWidth: CGFloat = Constants.Dimensions.deviceScreenWidth * self.sidebarViewScreenPercentageWidth
        return sidebarViewWidth
    }
    private var isDismissedLeadingConstant: CGFloat {
        return -(sidebarViewWidthConstant)
    }
    private let isDisplayedLeadingConstant: CGFloat = 0
    
    private var sidebarContainerViewLeadingAnchor: NSLayoutConstraint?
    private var sidebarContainerViewWidthAnchor: NSLayoutConstraint?
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        gesture.delegate = self
        return gesture
    }()
    
    private weak var applicationScreenWindow: UIWindow?
    private weak var rootViewController: UIViewController?
    
    private weak var delegate: SidebarViewDelegate?
    
    private var sidebarViewOrigin: CGPoint = CGPoint.zero
    
    
    
    
    
    
    
    
    private var sidebarItems: [[SidebarViewCellModelProtocol]] = [[]]
    private var sidebarReusableSectionItems: [SidebarViewReusableViewSectionProtocol] = []
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - UI Elements
    
     public private(set) lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    
    public private(set) lazy var backgroundBlurView: UIView = {
        var frame: CGRect = CGRect.zero
        let v = UIView(frame: CGRect.zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        // By default give it a dimmed background color
        // If user wants to add UIBlurEffect, this will be overriden
        v.backgroundColor = self.dimmedBackgroundColor
        v.isUserInteractionEnabled = true
        v.alpha = 0.0
        return v
    }()
    
    private var sidebarContainerView: SidebarViewContainer = {
        let v = SidebarViewContainer()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var sidebarCollectionView: SidebarCollectionView = {
        let cv = SidebarCollectionView()
        cv.backgroundColor = sidebarBackgroundColor
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Initializers
    
    public init(delegate: SidebarViewDelegate?) {
        super.init()
        
        self.delegate = delegate
        // Add as a subview to window and set delegate and datasource
        setupUIElementsWithKeyWindow()
    }
    
    @available(swift, obsoleted: 5.0, message: "This initializer has been deprecated. Use initializer with optional delegate argument and use SidebarView properties instead.")
    public init(delegate: SidebarViewDelegate?, dismissesOnSelection: Bool) {
        super.init()

        self.delegate = delegate
        // Add as a subview to window and set delegate and datasource
        setupUIElementsWithKeyWindow()

        self.dismissesOnSelection = dismissesOnSelection

    }

    @available(swift, obsoleted: 5.0, message: "This initializer has been deprecated. Use initializer with optional delegate argument and use SidebarView properties instead.")
    public init(delegate: SidebarViewDelegate?, dismissesOnSelection: Bool, pushesRootOnDisplay: Bool) {
        super.init()

        self.delegate = delegate
        // Add as a subview to window and set delegate and datasource
        setupUIElementsWithKeyWindow()

    }
    
    @available(swift, obsoleted: 5.0, message: "This initializer has been deprecated. Use initializer with optional delegate argument instead.")
    public override init() {
        super.init()
        
        setupUIElementsWithKeyWindow()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Functions
    
    private func setupUIElementsWithKeyWindow() {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError("No available keyWindow")
        }
        
        applicationScreenWindow = window
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(performDismissFromBackground(tapGesture:)))
        self.backgroundBlurView.addGestureRecognizer(dismissTapGesture)
        
        window.addSubview(containerView)
        containerView.addSubview(backgroundBlurView)
        containerView.addSubview(sidebarContainerView)
        
        sidebarContainerView.addSubview(sidebarCollectionView)
        
        
        containerView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        
        backgroundBlurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backgroundBlurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backgroundBlurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        backgroundBlurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        sidebarContainerViewLeadingAnchor = sidebarContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: isDismissedLeadingConstant)
        sidebarContainerViewLeadingAnchor?.isActive = true
        sidebarContainerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        sidebarContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sidebarContainerViewWidthAnchor = sidebarContainerView.widthAnchor.constraint(equalToConstant: sidebarViewWidthConstant)
        sidebarContainerViewWidthAnchor?.isActive = true
        
        sidebarCollectionView.leadingAnchor.constraint(equalTo: sidebarContainerView.leadingAnchor).isActive = true
        sidebarCollectionView.topAnchor.constraint(equalTo: sidebarContainerView.topAnchor).isActive = true
        sidebarCollectionView.trailingAnchor.constraint(equalTo: sidebarContainerView.trailingAnchor).isActive = true
        sidebarCollectionView.bottomAnchor.constraint(equalTo: sidebarContainerView.bottomAnchor).isActive = true
    }
    
    private func initializeBackgroundBlurView(withBlurEffect blurEffect: UIBlurEffect?) {
        // Chcek if user provided a blur effect. If not, do nothing
        if blurEffect != nil {
            if backgroundBlurEffectView != nil {
                backgroundBlurEffectView?.removeFromSuperview()
                backgroundBlurEffectView = nil
            }
            backgroundBlurEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundBlurEffectView?.translatesAutoresizingMaskIntoConstraints = false
            backgroundBlurView.addSubview(backgroundBlurEffectView!)
            
            backgroundBlurView.backgroundColor = UIColor.clear
            
            backgroundBlurEffectView?.leadingAnchor.constraint(equalTo: backgroundBlurView.leadingAnchor).isActive = true
            backgroundBlurEffectView?.topAnchor.constraint(equalTo: backgroundBlurView.topAnchor).isActive = true
            backgroundBlurEffectView?.trailingAnchor.constraint(equalTo: backgroundBlurView.trailingAnchor).isActive = true
            backgroundBlurEffectView?.bottomAnchor.constraint(equalTo: backgroundBlurView.bottomAnchor).isActive = true
            
            if self.backgroundBlurView.frame != .zero {
                // Immediately layout the  blur effect if changed manually later
                backgroundBlurView.layoutIfNeeded()
            }
            
            backgroundBlurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        }
    }
    
}













// MARK: - Animation

extension SidebarView {
    
    @available(*, unavailable, renamed: "show")
    public func showSidebarView() {
        performAnimationForSidebarView(shouldDisplay: true, completion: nil)
    }
    
    public func show() {
        performAnimationForSidebarView(shouldDisplay: true, completion: nil)
    }
    
    @objc private func performDismissFromBackground(tapGesture: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc public func dismiss() {
        
        performAnimationForSidebarView(shouldDisplay: false) {
            self.containerView.isHidden = true
        }
    }
    
    private func performAnimationForSidebarView(shouldDisplay: Bool, completion: (() -> ())?) {
        
        containerView.isHidden = false
        self.sidebarContainerViewLeadingAnchor?.constant = shouldDisplay ? isDisplayedLeadingConstant : isDismissedLeadingConstant
        
        let rootViewControllerOriginX: CGFloat = shouldDisplay ? sidebarViewWidthConstant : 0
        
        UIView.animate(withDuration: Constants.Animation.animationDuration,
                       delay: Constants.Animation.delay,
                       usingSpringWithDamping: Constants.Animation.springDamping,
                       initialSpringVelocity: Constants.Animation.springVelocity,
                       options: Constants.Animation.options,
                       animations: {
            
            self.backgroundBlurView.alpha = shouldDisplay ? 1.0 : 0.0
            
            self.applicationScreenWindow?.layoutIfNeeded()
            
            if self.shouldPushRootControllerOnDisplay == true {
                
                self.applicationScreenWindow?.visibleViewController()?.view.frame = CGRect(x: rootViewControllerOriginX,
                                                                                           y: 0,
                                                                                           width: Constants.Dimensions.deviceScreenWidth,
                                                                                           height: Constants.Dimensions.deviceScreenHeight)
                
            }
            
        }, completion: { (_) in
            self.sidebarViewIsShowing.toggle()
            completion?()
        })
    }
    
    
    
    
    
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        // Keep users from swiping even though the SidebarView is already showing
        guard sidebarViewIsShowing == false else { return }
        
        let threshold: CGFloat = Constants.Animation.panGestureScreenWidthThreshold
        
        if let window = applicationScreenWindow, let rootView = window.visibleViewController()?.view {
            
            let translation = panGesture.translation(in: rootView)
            
            
            if panGesture.state == .began {
                
                // Store old origin
                
                sidebarViewOrigin = self.sidebarCollectionView.frame.origin
                
            } else if panGesture.state == .ended || panGesture.state == .failed || panGesture.state == .cancelled {
                
                if translation.x >= rootView.frame.width * threshold {
                    show()
                } else {
                    dismiss()
                }
                
            } else {
                
                if translation.x >= rootView.frame.width * threshold {
                    show()
                } else {
                    let newOrigin: CGPoint = CGPoint(x: sidebarViewOrigin.x + (translation.x * 1.5),
                                                     y: sidebarViewOrigin.y)
                    
//                    self.sidebarCollectionView.frame.origin = newOrigin
                    self.sidebarContainerViewLeadingAnchor?.constant = newOrigin.x
                    
                    let percentToThreshold: CGFloat = (translation.x) / (rootView.frame.width * threshold)
                    self.backgroundBlurView.alpha = percentToThreshold
                }
            }
        }
        
    }
}









// MARK: - Models

extension SidebarView {
    
    public func insertSidebarView(models: [SidebarViewCellModelProtocol], atIndexPaths indexPaths: [IndexPath]) {
        guard models.count == indexPaths.count else {
            fatalError()
        }
        
        guard indexPaths.contains(where: { (indexPath) -> Bool in
            return indexPath.section < 0 || indexPath.item < 0
        }) == false else {
            fatalError("ModularSidebarView - IndexPaths must not contain negative values")
        }
       
        models.forEach { (model) in
            self.sidebarCollectionView.register(model.cellClass, forCellWithReuseIdentifier: model.cellReuseIdentifier)
        }
       
        let sortedIndexPaths = indexPaths.sorted(by: { $0.section < $1.section })
       
        for index in 0..<sortedIndexPaths.count {
            let indexPath = sortedIndexPaths[index]
            let itemToInsert = models[index]
           
            if indexPath.section > (self.sidebarItems.count - 1) {
                // create new section
               
                let newSection: [SidebarViewCellModelProtocol] = [itemToInsert]
                self.sidebarItems.append(newSection)
            } else {
               
                self.sidebarItems[indexPath.section].append(itemToInsert)
            }
        }
       
        sidebarCollectionView.reloadData()
    }
   
    public func insertReusableView(reusableSectionModels: [SidebarViewReusableViewSectionProtocol], atIndices indices: [Int]) {
        guard reusableSectionModels.count == reusableSectionModels.count else {
            fatalError()
        }
        
        guard indices.contains(where: { (value) -> Bool in
            return value < 0
        }) == false else {
            fatalError("ModularSidebarView - Section indices must not be negative")
        }
       
        reusableSectionModels.forEach { (reusableSectionModel) in
            
            if let header = reusableSectionModel.headerViewModel {
                self.sidebarCollectionView.register(header.reusableViewClass,
                                                    forSupplementaryViewOfKind: header.elementType.stringValue,
                                                    withReuseIdentifier: header.supplementaryViewReuseIdentifier)
            }
            
            if let footer = reusableSectionModel.footerViewModel {
                self.sidebarCollectionView.register(footer.reusableViewClass,
                                                    forSupplementaryViewOfKind: footer.elementType.stringValue,
                                                    withReuseIdentifier: footer.supplementaryViewReuseIdentifier)
            }
            
        }
       
        let sortedIndices = indices.sorted()
       
        for index in 0..<sortedIndices.count {
            let itemToInsert = reusableSectionModels[index]
           
            if index > (self.sidebarReusableSectionItems.count - 1) {
                // create new section
               
                self.sidebarReusableSectionItems.append(itemToInsert)
            } else {
               
                self.sidebarReusableSectionItems.insert(itemToInsert, at: index)
            }
        }
       
        sidebarCollectionView.reloadData()
    }

}










// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SidebarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sidebarItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sidebarItems[section].count
    }
    
    
    
    
    // Configure header
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableSectionItem = sidebarReusableSectionItems[indexPath.section]
        
        var reusableItem: SidebarViewReusableViewModelProtocol!
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            reusableItem = reusableSectionItem.headerViewModel
        case UICollectionView.elementKindSectionFooter:
            reusableItem = reusableSectionItem.footerViewModel
        default: fatalError()
        }
        
        let supplementaryItem = collectionView.dequeueReusableSupplementaryView(ofKind: reusableItem.elementType.stringValue,
                                                                                withReuseIdentifier: reusableItem.supplementaryViewReuseIdentifier,
                                                                                for: indexPath) as? SidebarReusableView
        
        supplementaryItem?.configure(with: reusableItem, at: indexPath)
        
        return supplementaryItem!
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section > (sidebarReusableSectionItems.count - 1)  {
            return CGSize.zero
        }
        
        if let _ = sidebarReusableSectionItems[section].headerViewModel {
            let width: CGFloat = collectionView.frame.width
            
            if let height = delegate?.sidebarView?(self, heightForHeaderIn: section) {
                  
                return CGSize(width: width, height: height)
            }
        }
        // Default
        return CGSize.zero
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section > (sidebarReusableSectionItems.count - 1)  {
            return CGSize.zero
        }
        
        if let _ = sidebarReusableSectionItems[section].headerViewModel {
            let width: CGFloat = collectionView.frame.width
            
            if let height = delegate?.sidebarView?(self, heightForFooterIn: section) {
                  
                return CGSize(width: width, height: height)
            }
        }
        // Default
        return CGSize.zero
        
    }
    
    
    
    
    // Configure Cell
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        
        if let height = delegate?.sidebarView?(self, heightForItemAt: indexPath) {
              
            return CGSize(width: width, height: height)
        }
        // Default
        return CGSize(width: width, height: Constants.Dimensions.defaultSidebarCellHeight)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.sidebarItems[indexPath.section][indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellReuseIdentifier,
                                                      for: indexPath) as? SidebarViewCell
        
        cell?.configure(with: item, at: indexPath)
        
        return cell!
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sidebarView?(self, didSelectItemAt: indexPath)
        
        if dismissesOnSelection {
            dismiss()
        }
    }
    
}













// MARK: - UIGestureRecognizerDelegate

extension SidebarView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let window = applicationScreenWindow, let controllerView = window.visibleViewController()?.view else { return false }
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: controllerView)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
    
}
