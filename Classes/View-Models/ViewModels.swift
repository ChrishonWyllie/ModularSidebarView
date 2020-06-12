//
//  ViewModels.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 6/10/20.
//

import Foundation

open class SidebarViewCellModel: SidebarViewCellModelProtocol {
    public private(set) var cellClass: AnyClass
    public var cellReuseIdentifier: String {
        return String(describing: type(of: cellClass))
    }
    
    public init(cellClass: AnyClass) {
        self.cellClass = cellClass
    }
}










open class SidebarViewReusableViewSectionModel: SidebarViewReusableViewSectionProtocol {
    public var headerViewModel: SidebarViewReusableViewModelProtocol?
    
    public var footerViewModel: SidebarViewReusableViewModelProtocol?
    
    public init(headerViewModel: SidebarViewReusableViewModelProtocol?, footerViewModel: SidebarViewReusableViewModelProtocol?) {
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
}

open class SidebarViewReusableViewModel: SidebarViewReusableViewModelProtocol {
    public private(set) var reusableViewClass: AnyClass
    
    public var supplementaryViewReuseIdentifier: String {
        return String(describing: type(of: reusableViewClass))
    }
    
    public var elementType: SidebarViewReusableViewModel.ElementType
    
    public enum ElementType {
        case header
        case footer

        var stringValue: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
   public init(reusableViewClass: AnyClass, elementType: SidebarViewReusableViewModel.ElementType) {
        self.reusableViewClass = reusableViewClass
        self.elementType = elementType
    }
}
