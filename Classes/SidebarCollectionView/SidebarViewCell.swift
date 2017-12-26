//
//  SidebarViewCell.swift
//  ModularSidebarView
//
//  Created by Chrishon Wyllie on 12/25/17.
//

import UIKit

// MARK: UICollectionView Cell

public class SidebarViewCell: UICollectionViewCell {
    
    public var optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Option"
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionLabel)
        
        if #available(iOS 9.0, *) {
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            optionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
