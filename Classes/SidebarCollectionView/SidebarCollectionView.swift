//
//  SidebarCollectionView.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

import UIKit

// MARK: - UICollectionView Header

internal class SidebarCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

internal class SidebarCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: SidebarCollectionViewLayout())
        setupInitialState()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialState() {
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
    }
}












class SidebarViewContainer: UIView {

    private var didLayoutSubviews: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()

        if didLayoutSubviews == false {
            didLayoutSubviews = true

            if willRoundCorners == true, let corners = cornersToRound {
                self.roundCorners(corners: corners, radius: radius)
            }
        }
    }

    private var willRoundCorners: Bool = false
    private var cornersToRound: UIRectCorner?
    private var radius: CGFloat = 0

    public func prepareToRound(corners: UIRectCorner, withRadius radius: CGFloat) {
        if didLayoutSubviews == false {
            self.willRoundCorners = true
            cornersToRound = corners
            self.radius = radius
        } else {
            self.roundCorners(corners: corners, radius: radius)
        }
    }
}
