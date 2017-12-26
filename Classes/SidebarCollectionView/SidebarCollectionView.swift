//
//  SidebarCollectionView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

import UIKit

public class SidebarCollectionView: UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        //print("side bar collection view did move to window")
        //print(self.frame.width, self.frame.height)
        //print(self.bounds.width, self.bounds.height)
        //print(self.frame)
        //roundCorners(corners: [.topRight, .bottomRight], radius: 30)
        //print(self.frame.width, self.frame.height)
        //print(self.bounds.width, self.bounds.height)
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
