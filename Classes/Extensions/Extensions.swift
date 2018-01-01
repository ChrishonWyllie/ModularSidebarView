//
//  Extensions.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 1/1/18.
//

import Foundation

///*
extension UIWindow {
    
    public func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewController(from: rootViewController)
        }
        return nil
    }
    
    public class func getVisibleViewController(from vc: UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as? UINavigationController
            return self.getVisibleViewController(from: (navigationController?.visibleViewController)!)
            //return UIWindow.getVisibleViewController(from: (navigationController?.visibleViewController)!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as? UITabBarController
            return self.getVisibleViewController(from: (tabBarController?.selectedViewController!)!)
            //return UIWindow.getVisibleViewController(from: (tabBarController?.selectedViewController!)!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return self.getVisibleViewController(from: presentedViewController.presentedViewController!)
                //return UIWindow.getVisibleViewController(from: presentedViewController.presentedViewController!)
                
            } else {
                
                return vc
            }
        }
    }
}
//*/
