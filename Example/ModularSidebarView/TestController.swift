//
//  TestController.swift
//  ModularSidebarView_Example
//
//  Created by Chrishon Wyllie on 1/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ModularSidebarView

class TestController: UITableViewController {
    
    let testData: [String] = ["test one",
                              "test two",
                              "test three",
                              "test four",
                              "test five",
                              "test six",
                              "test seven"]
    
    let sectionOneImageNames: [String] = ["some_image_one", "some_image_two", "some_image_three", "some_image_four", "some_image_five"]
    let sectionOneOptionTitles: [String] = ["Home", "Account", "Transactions", "Help", "Some option"]
    
    let sectionTwoImageNames: [String] = ["some_image_one", "some_image_two"]
    let sectionTwoOptionTitles: [String] = ["Settings", "Log out"]

    // For if you want allowSwipeToDisplay
    private var sidebarView: SidebarView?
    
    lazy var sidebarButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Side", style: .done, target: self, action: #selector(openSidebarView(_:)))
        return btn
    }()
    
    @objc private func openSidebarView(_ sender: Any) {
        sidebarView?.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sidebarView = SidebarView(delegate: self)
        sidebarView?.sidebarViewScreenPercentageWidth = 0.5
        
        self.navigationItem.leftBarButtonItem = sidebarButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupSidebarViewItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let someTestString = testData[indexPath.row]
        
        cell?.textLabel?.text = someTestString
        
        return cell!
        
    }
    
    private func setupSidebarViewItems() {
        let sectionOneIndexPaths = Array(0..<sectionOneOptionTitles.count).map { IndexPath(item: $0, section: 0) }
        let sectionOneItems: [SidebarViewCellModel] = zip(sectionOneImageNames, sectionOneOptionTitles).map { (imageName, title) -> SidebarViewCellModel in
            return CustomSidebarCellModel(image: nil, title: title)
        }
        
        let sectionTwoIndexPaths = Array(0..<sectionTwoOptionTitles.count).map { IndexPath(item: $0, section: 1) }
        let sectionTwoItems: [SidebarViewCellModel] = zip(sectionTwoImageNames, sectionTwoOptionTitles).map { (imageName, title) -> SidebarViewCellModel in
            return CustomSidebarCellModel(image: nil, title: title)
        }
        
        let items = (sectionOneItems + sectionTwoItems)
        let indexPaths = (sectionOneIndexPaths + sectionTwoIndexPaths)
        
        sidebarView?.insertSidebarView(models: items, atIndexPaths: indexPaths)
        
        
        let reusableSectionItems: [SidebarViewReusableViewSectionModel] = [
            
            SidebarViewReusableViewSectionModel(headerViewModel: CustomSidebarSectionHeaderModel(),
                                                footerViewModel: CustomSidebarSectionFooterModel()),
            SidebarViewReusableViewSectionModel(headerViewModel: CustomSidebarSectionHeaderModel(),
                                                footerViewModel: CustomSidebarSectionFooterModel())
        ]
        
        let indices = [0, 1]
        
        sidebarView?.insertReusableView(reusableSectionModels: reusableSectionItems, atIndices: indices)

    }
}


extension TestController: SidebarViewDelegate {
    
    // Configure SidebarView
    
    func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath) {
        var infoToPass: String
        let detailViewController = DetailViewController()
        switch indexPath.section {
        case 0:
            print(sectionOneOptionTitles[indexPath.item])
            infoToPass = sectionOneOptionTitles[indexPath.item]
        default:
            print(sectionTwoOptionTitles[indexPath.item])
            infoToPass = sectionTwoOptionTitles[indexPath.item]
        }
        detailViewController.passedInfoString = infoToPass
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat {
        return section == 0 ? 200 : 1
    }
    
    func sidebarView(_ view: SidebarView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 40
        }
    }
}

