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
    
    private let cellReuseIdentifier = "Cell"
    private lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    
    let testData: [String] = ["test one",
                              "test two",
                              "test three",
                              "test four",
                              "test five",
                              "test six",
                              "test seven"]
    
    let sectionOneImageNames: [String] = ["some_image_one", "some_image_two", "some_image_three", "some_image_four", "some_image_five", "", "", ""]
    let sectionOneOptionTitles: [String] = ["Home", "Account", "Transactions", "Help", "Some option", "bleh", "bleh", "bleh"]
    
    let sectionTwoImageNames: [String] = ["some_image_one", "some_image_two"]
    let sectionTwoOptionTitles: [String] = ["Settings", "Log out"]
    
    lazy var sidebarButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Side", style: .done, target: self, action: #selector(openSidebarView(_:)))
        return btn
    }()
    
    
    private lazy var newControllerButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(pushTestController(_:)))
        return btn
    }()
    
    @objc private func pushTestController(_ sender: Any) {
        let navController = UINavigationController(rootViewController: TestController())
        self.present(navController, animated: true, completion: nil)
    }
    
    
    // For if you want allowSwipeToDisplay
    private lazy var sidebarView: SidebarView = {
        let sbv = SidebarView(delegate: self)
        sbv.sidebarBackgroundColor = UIColor.groupTableViewBackground
        sbv.blurBackgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        sbv.dismissesOnSelection = true
        sbv.allowsPullToDisplay = true
        sbv.shouldPushRootControllerOnDisplay = true
        sbv.sidebarCornerRadius = 25.0
        sbv.sidebarViewScreenPercentageWidth = 0.7
        return sbv
    }()
    
    @objc private func openSidebarView(_ sender: Any) {
        sidebarView.show()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.navigationItem.leftBarButtonItem = sidebarButton
        self.navigationItem.rightBarButtonItem = newControllerButton
        
        setupSidebarViewItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        sidebarView.insertSidebarView(models: items, atIndexPaths: indexPaths)
        
        
        let reusableSectionItems: [SidebarViewReusableViewSectionModel] = [
            
            SidebarViewReusableViewSectionModel(headerViewModel: CustomSidebarSectionHeaderModel(),
                                                footerViewModel: CustomSidebarSectionFooterModel()),
            SidebarViewReusableViewSectionModel(headerViewModel: CustomSidebarSectionHeaderModel(),
                                                footerViewModel: CustomSidebarSectionFooterModel())
        ]
        
        let indices = [0, 1]
        
        sidebarView.insertReusableView(reusableSectionModels: reusableSectionItems, atIndices: indices)
        
    }
}












// MARK: - UITableViewDelegate and UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        let someTestString = testData[indexPath.row]
        
        cell?.textLabel?.text = someTestString
        
        return cell!
        
    }
    
}
















// MARK: - SidebarViewDelegate

extension ViewController: SidebarViewDelegate {
    
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
        return section == 0 ? 200 : 100
    }
    
    func sidebarView(_ sidebarView: SidebarView, heightForFooterIn section: Int) -> CGFloat {
        return 200.0
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















// MARK: - Test models and SidebarView UI elements

class CustomSidebarSectionHeaderModel: SidebarViewReusableViewModel {
    
    init() {
        super.init(reusableViewClass: CustomSidebarSectionHeader.self, elementType: .header)
    }
}

class CustomSidebarSectionFooterModel: SidebarViewReusableViewModel {
    
    init() {
        super.init(reusableViewClass: CustomSidebarSectionHeader.self, elementType: .footer)
    }
}

class CustomSidebarSectionHeader: SidebarReusableView {
    
    override func configure(with item: SidebarViewReusableViewModelProtocol, at indexPath: IndexPath) {

    }
    
    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var customOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Option"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(customImageView)
        addSubview(customOptionLabel)
        
        self.backgroundColor = [UIColor.red, .orange, .yellow, .green, .blue, .purple].randomElement()
        
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

class CustomSidebarCellModel: SidebarViewCellModel {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
        super.init(cellClass: CustomSidebarCell.self)
    }
}


class CustomSidebarCell: SidebarViewCell {
    
    override func configure(with item: SidebarViewCellModelProtocol, at indexPath: IndexPath) {
        super.configure(with: item, at: indexPath)
        guard let item = item as? CustomSidebarCellModel else { fatalError() }
        
        self.customOptionLabel.text = item.title
    }
    
    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    var customOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Option"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(customImageView)
        addSubview(customOptionLabel)
        
        self.backgroundColor = UIColor.darkGray// [UIColor.red, .orange, .yellow, .green, .blue, .purple].randomElement()
        
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
