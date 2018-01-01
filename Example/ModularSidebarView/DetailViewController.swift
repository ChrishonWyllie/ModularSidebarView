//
//  DetailViewController.swift
//  ModularSidebarView_Example
//
//  Created by Chrishon Wyllie on 1/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    public var passedInfoString: String? {
        didSet {
            label.text = passedInfoString
        }
    }
    
    public var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        lbl.font = UIFont.init(name: "Arial", size: 36)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
