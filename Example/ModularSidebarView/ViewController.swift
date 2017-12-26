//
//  ViewController.swift
//  ModularSidebarView
//
//  Created by ChrishonWyllie on 12/25/2017.
//  Copyright (c) 2017 ChrishonWyllie. All rights reserved.
//

import UIKit
import ModularSidebarView

class ViewController: UIViewController {
    
    let sectionOneImageNames: [String] = ["defaultProfileImage_black", "TakePhotoButton", "ChangeCameraFlashButton", "DownloadToCameraRollButton", "ChangeCamera", "DrawButton", "ImageFilterIcon"]
    let sectionOneOptionTitles: [String] = ["Home", "Upload", "UITest", "ProgressHUDs", "BLETest", "CustomMapView", "FilterTest"]
    
    let sectionTwoImageNames: [String] = []
    let sectionTwoOptionTitles: [String] = ["Settings", "Log out"]
    
    lazy var sidebarButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Side", style: .done, target: self, action: #selector(openSidebarView(_:)))
        return btn
    }()
    
    private lazy var sidebarView: SidebarView = {
        //let sbv = SidebarView()
        let sbv = SidebarView(dismissesOnSelection: true)
        sbv.delegate = self
        //sbv.datasource = self
        //sbv.dismissesOnSelection = false
        return sbv
    }()
    
    @objc private func openSidebarView(_ sender: Any) {
        sidebarView.showSidebarView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = sidebarButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SidebarViewDelegate {
    
    // Configure SidebarView
    
    func numberOfSections(in sidebarView: SidebarView) -> Int {
        return 2
    }
    
    func sidebarView(_ sidebarView: SidebarView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? sectionOneOptionTitles.count : sectionTwoOptionTitles.count
    }
    
    func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(sectionOneOptionTitles[indexPath.item])
        default:
            print(sectionTwoOptionTitles[indexPath.item])
        }
    }
        
    var sidebarViewWidth: CGFloat {
        get { return 0.8 }
    }
    
    var sidebarViewBackgroundColor: UIColor {
        get { return .white }
    }
    
    var blurBackgroundStyle: UIBlurEffectStyle {
        get { return UIBlurEffectStyle.dark }
    }
    
    
    
    
    
    // Configure headers
    
    func willDisplayHeaders() -> Bool {
        return true
    }
    
    func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView()
            
            let dismissButton: UIButton = {
                let btn = UIButton(type: .system)
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.setTitle("X", for: .normal)
                btn.setTitleColor(UIColor(red: 0, green: 240/255, blue: 180/255, alpha: 1.0), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                //btn.addTarget(sidebarView, action: #selector(sidebarView.dismiss), for: .touchUpInside)
                return btn
            }()
            
            let settingsButton: UIButton = {
                let btn = UIButton(type: .system)
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.setTitle("Settings", for: .normal)
                btn.setTitleColor(UIColor(red: 0, green: 240/255, blue: 180/255, alpha: 1.0), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                return btn
            }()
            
            let imageView: UIImageView = {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
                imageView.layer.borderWidth = 1
                imageView.clipsToBounds = true
                return imageView
            }()
            
            let titleLabel: UILabel = {
                let lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.text = "Chrishon Wyllie"
                lbl.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
                lbl.font = UIFont.systemFont(ofSize: 20)
                return lbl
            }()
            
            headerView.addSubview(dismissButton)
            headerView.addSubview(settingsButton)
            headerView.addSubview(imageView)
            headerView.addSubview(titleLabel)
            
            dismissButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
            dismissButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16).isActive = true
            dismissButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
            settingsButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16).isActive = true
            settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24).isActive = true
            imageView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.layer.cornerRadius = 35
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24).isActive = true
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
            
            //headerView.backgroundColor = .yellow
            
            return headerView
        default:
            let dividerView = UIView()
            
            dividerView.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
            
            return dividerView
        }
    }
    
    func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat {
        return section == 0 ? 200 : 1
    }
    
    
    
    
    
    // Configure cells
    
    func registerCustomCellForSidebarView() -> AnyClass {
        return CustomSidebarCell.self
    }
    
    func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let customCell = cell as? CustomSidebarCell {
            
            customCell.customOptionLabel.font = UIFont(name: "Avenir Next", size: 20)
            
            switch indexPath.section {
            case 0:
                
                customCell.customOptionLabel.text = sectionOneOptionTitles[indexPath.item]
                customCell.customOptionLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
                
                if let maskedImage = UIImage(named: sectionOneImageNames[indexPath.item]) {
                    customCell.customImageView.image = maskedImage
                }
            case 1:
                
                customCell.customImageView.backgroundColor = .blue
                customCell.customOptionLabel.text = sectionTwoOptionTitles[indexPath.item]
            default: break
            }
        }
    }
    
    var sidebarCellBackgroundColor: UIColor {
        get { return .white }
    }
    
    func sidebarView(titlesForItemsIn section: Int) -> [String] {
        return section == 0 ? sectionOneOptionTitles : sectionTwoOptionTitles
    }
    
    func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont? {
        return UIFont(name: "Arial", size: 18)
    }
    
    func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor? {
        return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    }
    
    func sidebarView(heightForItemIn section: Int) -> CGFloat {
        return 60
    }
    
}













class CustomSidebarCell: UICollectionViewCell {
    
    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        //imageView.layer.borderColor = UIColor.darkGray.cgColor
        //imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var customOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //label.textColor = .white
        label.text = "Option"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(customImageView)
        addSubview(customOptionLabel)
        
        
        customImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        customImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        customImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        customImageView.layer.cornerRadius = 20
        
        
        customOptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        customOptionLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
