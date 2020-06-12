//
//  SidebarReusableView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 6/10/20.
//

import UIKit

open class SidebarReusableView: UICollectionReusableView, ConfigurableReusableView {
    public typealias ReusableViewModelClass = SidebarViewReusableViewModelProtocol
    
    open func configure(with item: SidebarViewReusableViewModelProtocol, at indexPath: IndexPath) {
        
    }
}
