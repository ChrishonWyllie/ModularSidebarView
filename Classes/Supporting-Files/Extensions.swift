//
//  Extensions.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 1/1/18.
//

import Foundation

extension UIWindow {
    
    public func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewController(from: rootViewController)
        }
        return nil
    }
    
    public class func getVisibleViewController(from viewController: UIViewController) -> UIViewController {
        
        if viewController.isKind(of: UINavigationController.self) {
            
            let navigationController = viewController as? UINavigationController
            return self.getVisibleViewController(from: (navigationController?.visibleViewController)!)
            
        } else if viewController.isKind(of: UITabBarController.self) {
            
            let tabBarController = viewController as? UITabBarController
            return self.getVisibleViewController(from: (tabBarController?.selectedViewController!)!)
            
        } else {
            
            if let presentedViewController = viewController.presentedViewController {
                
                return self.getVisibleViewController(from: presentedViewController.presentedViewController!)
                
            } else {
                
                return viewController
            }
        }
    }
}







extension UIView {
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if self.layer.mask != nil {
            self.layer.mask = nil
            superview?.layoutIfNeeded()
        }
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
