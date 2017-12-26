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
    
    @objc optional func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath)
    
    //@objc optional func roundCorners() -> [UIRectCorner]
    
    // For settings specific colors for each item manually instead of blanket coloring every cell
    @objc optional func sidebarView(backgroundColor color: UIColor, forItemAt IndexPath: IndexPath) -> UIColor
    
    // Determine width of SidebarView using percentage of device screen. Default is 0.80
    @objc optional var sidebarViewWidth: CGFloat { get }
    
    // Determine background color of the SidebarView
    @objc optional var sidebarViewBackgroundColor: UIColor { get }
    
    // Determine color of the "blur" view in the background. Essentially the darkening effect that appears over the unerlying viewcontroller
    @objc optional var backgroundColor: UIColor { get }
    
    @objc optional var blurBackgroundStyle: UIBlurEffectStyle { get }
    
    
    
    
    
    
    
    // MARK: - Configure Headers
    
    @objc optional func willDisplayHeaders() -> Bool
    
    @objc optional func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView?
    
    @objc optional func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat
    
    // Determine the title of the each UICollectionReusableView
    //@objc optional func sidebarView(_ collectionView: UICollectionView, titleForHeaderIn section: Int) -> String?
    
    
    
    
    
    
    
    
    // MARK: - Configure Cells
    
    // For creating custom cells
    @objc optional func registerCustomCellForSidebarView() -> AnyClass
    
    @objc optional func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    
    
    
    // Determine background color of the SidebarViewCell
    @objc optional var sidebarCellBackgroundColor: UIColor { get }
    
    // Determine the actual title of each UICollectionViewCell
    func sidebarView(titlesForItemsIn section: Int) -> [String]
    
    // Font of UILabel in SidebarViewCell
    @objc optional func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont?
    
    // TextColor of UILabel in SidebarViewCell
    @objc optional func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor?
    
    // Determine height of each cell
    @objc optional func sidebarView(heightForItemIn section: Int) -> CGFloat
    
    
    
    
    
    
    
    
    /*
    // MARK: - Configure SidebarView
    
    static func numberOfSections(in sidebarView: SidebarView) -> Int
    
    static func sidebarView(_ sidebarView: SidebarView, numberOfItemsInSection section: Int) -> Int
    
    @objc static optional func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath)
        
    // For settings specific colors for each item manually instead of blanket coloring every cell
    @objc static optional func sidebarView(backgroundColor color: UIColor, forItemAt IndexPath: IndexPath) -> UIColor
    
    // Determine width of SidebarView using percentage of device screen. Default is 0.80
    @objc static optional var sidebarViewWidth: CGFloat { get }
    
    // Determine background color of the SidebarView
    @objc static optional var sidebarViewBackgroundColor: UIColor { get }
    
    // Determine color of the "blur" view in the background. Essentially the darkening effect that appears over the unerlying viewcontroller
    @objc static optional var backgroundColor: UIColor { get }
    
    @objc static optional var blurBackgroundStyle: UIBlurEffectStyle { get }
    
    
    
    
    
    
    
    // MARK: - Configure Headers
    
    @objc static optional func willDisplayHeaders() -> Bool
    
    @objc static optional func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView?
    
    @objc static optional func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat
    
    // Determine the title of the each UICollectionReusableView
    //@objc optional func sidebarView(_ collectionView: UICollectionView, titleForHeaderIn section: Int) -> String?
    
    
    
    
    
    
    
    
    // MARK: - Configure Cells
    
    // For creating custom cells
    @objc static optional func registerCustomCellForSidebarView() -> AnyClass
    
    @objc static optional func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    
    
    
    // Determine background color of the SidebarViewCell
    @objc static optional var sidebarCellBackgroundColor: UIColor { get }
    
    // Determine the actual title of each UICollectionViewCell
    static func sidebarView(titlesForItemsIn section: Int) -> [String]
    
    // Font of UILabel in SidebarViewCell
    @objc static optional func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont?
    
    // TextColor of UILabel in SidebarViewCell
    @objc static optional func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor?
    
    // Determine height of each cell
    @objc static optional func sidebarView(heightForItemIn section: Int) -> CGFloat
    */
    
}
