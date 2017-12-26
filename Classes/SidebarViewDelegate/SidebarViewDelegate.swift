//
//  SidebarViewDelegate.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

import UIKit

@objc public protocol SidebarViewDelegate: class {
    
    // MARK: - Configure SidebarView
    
    func numberOfSections(in sidebarView: SidebarView) -> Int
    
    func sidebarView(_ sidebarView: SidebarView, numberOfItemsInSection section: Int) -> Int
    
    // Use this to provide an action to when a cell is selected. Similar to UITableView or UICollectionView functionality
    @objc optional func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath)
    
    // For settings specific colors for each item manually instead of blanket coloring every cell
    @objc optional func sidebarView(backgroundColor color: UIColor, forItemAt IndexPath: IndexPath) -> UIColor
    
    // Determine width of SidebarView using percentage of device screen. Default is 0.80 (80 %) of the screen
    @objc optional var sidebarViewWidth: CGFloat { get }
    
    // Determine background color of the SidebarView
    @objc optional var sidebarViewBackgroundColor: UIColor { get }
    
    // Determine color of the "blur" view in the background. Essentially the darkening effect that appears over the unerlying viewcontroller
    @objc optional var backgroundColor: UIColor { get }
    
    // Determine the style of the "blur" view. Options: .dark, .light, .extraLight
    @objc optional var blurBackgroundStyle: UIBlurEffectStyle { get }
    
    // Determine whether the SidebarView will push the underlying rootViewController over when displayed
    // or simply Cover it
    @objc optional var shouldPushRootViewControllerOnDisplay: Bool { get }
    
    // Round the topRight and bottomRight corners of the SidebarView
    @objc optional func shouldRoundCornersWithRadius() -> CGFloat
    
    
    
    
    // MARK: - Configure Headers
    
    @objc optional func willDisplayHeaders() -> Bool
    
    // Provide your own view to be added to the Header in each section of the SidebarView
    @objc optional func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView?
    
    // Configure the height of each header
    @objc optional func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat
    
    
    
    
    
    
    
    
    // MARK: - Configure Cells
    
    // For creating custom cells. Return your own UICollectionViewCell class to be registered
    @objc optional func registerCustomCellForSidebarView() -> AnyClass
    
    // Provide custom configurations for your custom cell
    @objc optional func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    // Determine background color of the SidebarViewCell
    @objc optional var sidebarCellBackgroundColor: UIColor { get }
    
    // Determine the actual title of each UICollectionViewCell
    func sidebarView(titlesForItemsIn section: Int) -> [String]
    
    
    
    // !!!
    // These three optional delegate functions work for the DEFAULT SidebarViewCell. If you provide a custom cell, don't use these
    
    // Font of UILabel in SidebarViewCell
    @objc optional func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont?
    
    // TextColor of UILabel in SidebarViewCell
    @objc optional func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor?
    
    // Determine height of each cell
    @objc optional func sidebarView(heightForItemIn section: Int) -> CGFloat
    
}
