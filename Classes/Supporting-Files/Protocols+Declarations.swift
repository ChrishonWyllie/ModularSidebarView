//
//  Protocols+Declarations.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 6/10/20.
//

import UIKit


// MARK: - SidebarView CollectionView

/// Protocol by which view-models that represent SidebarView cells must conform to
public protocol SidebarViewCellModelProtocol {
    /// The UICollectionViewCell class that will be displayed in the SidebarView
    /// e.g.: UICollectionViewCell.self
    var cellClass: AnyClass { get }
    
    /// reuse identifier of the cell.
    /// Must return a String representation of the name of the cellClass
    /*:
        String(describing: type(of: cellClass))
    */
    var cellReuseIdentifier: String { get }
}

public protocol SidebarViewReusableViewSectionProtocol: class {
    var headerViewModel: SidebarViewReusableViewModelProtocol? { get }
    var footerViewModel: SidebarViewReusableViewModelProtocol? { get }
}

/// Protocol by which view-models that represent SidebarView supplementary views must conform to
public protocol SidebarViewReusableViewModelProtocol {
    /// The UICollectionReusableView class that will be displayed in the SidebarView
    /// e.g.: UICollectionReusableView.self
    var reusableViewClass: AnyClass { get }
    
    /// reuse identifier for the supplementary view
    /// Must return a String representation of the name of the cellClass
    /*:
        String(describing: type(of: reusableViewClass))
    */
    var supplementaryViewReuseIdentifier: String { get }
    var elementType: SidebarViewReusableViewModel.ElementType { get }
}

/// Protocol by which UICollectionViewCells will conform to.
/// Provides overridable function to configure the cell with the CellModel
/// This is not intended for users to conform to directly. Instead, subclass
/// the SidebarViewCell and override its configure(with:at:) function
public protocol ConfigurableSidebarViewCell: class {
    associatedtype CellModelClass
    func configure(with item: CellModelClass, at indexPath: IndexPath)
}

/// Protocol by which UICollectionReusableViews will conform to.
/// Provides overridable function to configure the view with the ReusableViewModel
/// This is not intended for users to conform to directly. Instead, subclass the
/// SidebarReusableView and override its configure(with:at:) function
public protocol ConfigurableReusableView: class {
    associatedtype ReusableViewModelClass
    func configure(with item: ReusableViewModelClass, at indexPath: IndexPath)
}
















// MARK: - SidebarViewDelegate

@objc public protocol SidebarViewDelegate: class {
    
    // Use this to provide an action to when a cell is selected. Similar to UITableView or UICollectionView functionality
    @objc optional func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath)
    
    // Configure the height of each header
    @objc optional func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat
    
    @objc optional func sidebarView(_ sidebarView: SidebarView, heightForFooterIn section: Int) -> CGFloat
    
    // Determine height of each cell
    @available(swift, obsoleted: 5.0, renamed: "sidebarView(_:heightForItemAt:)")
    @objc optional func sidebarView(heightForItemIn section: Int) -> CGFloat
    @objc optional func sidebarView(_ view: SidebarView, heightForItemAt indexPath: IndexPath) -> CGFloat
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Deprecated
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's sidebarViewScreenPercentageWidth property instead")
    // Determine width of SidebarView using percentage of device screen. Default is 0.80 (80 %) of the screen
    @objc optional var sidebarViewWidth: CGFloat { get }
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's allowsPullToDisplay property instead")
    // Allow users to swipe to the right in order to display the SidebarView
    @objc optional var allowsPullToDisplay: Bool { get }
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's blurBackgroundEffect property instead")
    // Determine the style of the "blur" view. Options: .dark, .light, .extraLight
    @objc optional var blurBackgroundStyle: UIBlurEffect.Style { get }
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's sidebarBackgroundColor property instead")
    // Determine background color of the SidebarView
    @objc optional var sidebarViewBackgroundColor: UIColor { get }
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's shouldPushRootControllerOnDisplay property instead")
    // Determine whether the SidebarView will push the underlying rootViewController over when displayed
    // or simply Cover it
    @objc optional var shouldPushRootViewControllerOnDisplay: Bool { get }
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's sidebarCornerRadius property instead")
    // Round the topRight and bottomRight corners of the SidebarView
    @objc optional func shouldRoundCornersWithRadius() -> CGFloat
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Use SidebarView's sidebarBackgroundColor property instead")
    // Determine color of the "blur" view in the background. Essentially the darkening effect that appears over the unerlying viewcontroller
    @objc optional var backgroundColor: UIColor { get }
    
    
    
    
    
    
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    @objc optional func willDisplayHeaders() -> Bool
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    func numberOfSections(in sidebarView: SidebarView) -> Int
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    func sidebarView(_ sidebarView: SidebarView, numberOfItemsInSection section: Int) -> Int
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // For settings specific colors for each item manually instead of blanket coloring every cell
    @objc optional func sidebarView(backgroundColor color: UIColor, forItemAt IndexPath: IndexPath) -> UIColor
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // For creating custom cells. Return your own UICollectionViewCell class to be registered
    @objc optional func registerCustomCellForSidebarView() -> AnyClass
        
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // Provide custom configurations for your custom cell
    @objc optional func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
        
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // Determine background color of the SidebarViewCell
    @objc optional var sidebarCellBackgroundColor: UIColor { get }
        
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // Determine the actual title of each UICollectionViewCell
    func sidebarView(titlesForItemsIn section: Int) -> [String]
        
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // Font of UILabel in SidebarViewCell
    @objc optional func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont?
        
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // TextColor of UILabel in SidebarViewCell
    @objc optional func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor?
    
    @available(swift, obsoleted: 5.0, message: "This has been deprecated. Provide custom ViewModels instead")
    // Provide your own view to be added to the Header in each section of the SidebarView
    @objc optional func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView?
    
}
