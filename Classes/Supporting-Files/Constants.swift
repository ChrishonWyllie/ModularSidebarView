//
//  Constants.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 6/10/20.
//

import UIKit

internal struct Constants {
    
    private init() {}
    
    struct Dimensions {
        private init() {}
        
        static var deviceScreenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        static var deviceScreenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        static var defaultScreenWidthPercentage: CGFloat {
            return 0.75
        }
        
        static var defaultSidebarCellHeight: CGFloat {
            return 60.0
        }
    }
    
    struct Colors {
        private init() {}
        
        static let defaultDimmedViewBackground: UIColor = UIColor(white: 0.0, alpha: 0.5)
        static let defaultSidebarCollectionViewBackground: UIColor = UIColor.white
    }
    
    struct Animation {
        private init() {}
        
        static let animationDuration: TimeInterval = 0.5
        static let delay: TimeInterval = 0.0
        static let springDamping: CGFloat = 1.0
        static let springVelocity: CGFloat = 0.5
        static let options: UIView.AnimationOptions = [.curveEaseInOut]
        
        
        static let panGestureScreenWidthThreshold: CGFloat = 0.35
    }
}
