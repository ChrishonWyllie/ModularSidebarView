# ModularSidebarView

[![CI Status](http://img.shields.io/travis/ChrishonWyllie/ModularSidebarView.svg?style=flat)](https://travis-ci.org/ChrishonWyllie/ModularSidebarView)
[![Version](https://img.shields.io/cocoapods/v/ModularSidebarView.svg?style=flat)](http://cocoapods.org/pods/ModularSidebarView)
[![License](https://img.shields.io/cocoapods/l/ModularSidebarView.svg?style=flat)](http://cocoapods.org/pods/ModularSidebarView)
[![Platform](https://img.shields.io/cocoapods/p/ModularSidebarView.svg?style=flat)](http://cocoapods.org/pods/ModularSidebarView)

</p>
ModularSidebarView is a customizable menu for displaying options on the side of the screen for iOS. It is meant to act as a substitute to the usual UINavigation bar items and tool bar items.
</p>

<br />
<br />
<div id="images">
<img style="display: inline; margin: 0 5px;" src="Github Images/ModularSidebarView-home-screen_iphonexspacegrey_portrait.png" width=220 height=440 />
<img style="display: inline; margin: 0 5px;" src="Github Images/ModularSidebarView-sidebarview-screen_iphonexspacegrey_portrait.png" width=220 height=440 />
</div>

## Usage


<h3>Displaying the SidebarView</h3>

<p>First, initialize the SideBarView</p>

```swift
private lazy var sidebarView: SidebarView = {
    let sbv = SidebarView(delegate: self)
    // Make desired configurations
    return sbv
}()
```

<br />
<br />



<p>Then create some sort of UIButton, UIBarButtonItem or any view with userInteraction enabled. Create the selector and function however you choose.</p>

```swift
// It is NOT required to a use a UIBarButtonItem to display the SidebarView. 
// Provide your own implementation for triggering the SidebarView to show.
private lazy var sidebarButton: UIBarButtonItem = {
    let btn = UIBarButtonItem(title: "Sidebar", 
                              style: .done, 
                              target: self, 
                              action: #selector(openSidebarView(_:)))
    return btn
}()

// Here, we call the "showSidebarView()" function to display the SidebarView
@objc private func openSidebarView(_ sender: Any) {
    sidebarView.show()
}

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    // ... Other UI setup

    // Place the sidebarButton in the navigationBar if desired.
    self.navigationItem.leftBarButtonItem = sidebarButton
}
```


<h3>Dismissing the SidebarView</h3>

```swift

private func dismissSidebarView() {
    sidebarView.dismiss()
}

```
<ul>
    <li><p>Simply tap the background view</p></li>
    <li><p>Or pressing one of the options in the SidebarView will also dismiss on selection if dismissesOnSelection set to TRUE</p></li>
</ul>




## Adding items to the SidebarView
<h3>The SidebarView uses a View-Model approach to laying out items.</h3>
<p>You may subclass the default provided classes or conform to the underlying protocol for more customization</p>

### Step 1: Creating View-Models</h3>
#### Subclassing the `SidebarViewCellModel`, `SidebarViewReusableViewSectionModel` and `SidebarViewReusableViewModel`

```swift

// SidebarViewCellModel is the View-Model that represents a SidebarView cell
// CustomSidebarCellModel is a custom subclass. You may provide your own subclass
class CustomSidebarCellModel: SidebarViewCellModel {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
        
        // This is very imporant. Provide the cell class you wish for this model to display
        // This must be a UICollectionViewCell
        super.init(cellClass: CustomSidebarCell.self)
    }
}
```
```swift

// At heart, SidebarView is a UICollectionView.
// As such, may render both a header and footer supplementaryView for each section.
// The SidebarViewReusableViewSectionModel provides a container for both the header and footer in each section.

SidebarViewReusableViewSectionModel(headerViewModel: SidebarViewReusableViewModelProtocol?, footerViewModel: SidebarViewReusableViewModelProtocol?)

// You create your own header and footer supplementary view-models that conform to SidebarViewReusableViewModelProtocol or subclass the default SidebarViewReusableViewModel:

class CustomHeaderModel: SidebarViewReusableViewModel {
    
    init() {
        super.init(reusableViewClass: CustomSidebarSectionHeader.self, elementType: .header)
    }
}

class CustomFooterModel: SidebarViewReusableViewModel {
    
    init() {
        super.init(reusableViewClass: CustomSidebarSectionHeader.self, elementType: .footer)
    }
}
```

### Step 2: Creating Views (Cells and ReusableViews)
#### Subclassing the `SidebarViewCell` and  `SidebarReusableView`

```swift

class CustomSidebarCell: SidebarViewCell {

    // Important to override this function to configure the cells as desired
    override func configure(with item: SidebarViewCellModelProtocol, at indexPath: IndexPath) {
        super.configure(with: item, at: indexPath)
        guard let customViewModel = item as? CustomSidebarCellModel else { 
            return
        }
        
        // configure the cell with your custom View-Model data
        self.imageView.image = customViewModel.image
        
        self.titleLabel.text = customViewModel.title
    }
}

class CustomSidebarSectionHeader: SidebarReusableView {

    // Important to override this function to configure the view as desired
    override func configure(with item: SidebarViewReusableViewModelProtocol, at indexPath: IndexPath) {
        super.configure(with: item, at: indexPath)
        guard let customViewModel = item as? CustomHeaderModel else {
            return
        }
        
        // configure the cell with your custom header View-Model data
        
    }
}

```

### Step 3: Inserting the View-Models into the SidebarView
#### Use these two functions to insert Cell and ReusableView View-Models at desired indexPaths

```swift

func insertSidebarView(models: [SidebarViewCellModelProtocol], atIndexPaths indexPaths: [IndexPath])

func insertReusableView(reusableSectionModels: [SidebarViewReusableViewSectionProtocol], atIndices indices: [Int])
```

<h1>Example</h1>

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    setupSidebarViewItems()
    
}

private func setupSidebarViewItems() {

    // Create Cell View-Models

    let sectionOneIndexPaths: [IndexPath = // ... Construct array of IndexPaths for section 0
    let sectionOneItems: [SidebarViewCellModelProtocol] = // ... Construct array of View-Models for section 0
    
    let sectionTwoIndexPaths: [IndexPath = // ... Construct array of IndexPaths for section 1
    let sectionTwoItems: [SidebarViewCellModelProtocol] = // ... Construct array of View-Models for section 1
    
    let completeListOfItems: [SidebarViewCellModelProtocol] = (sectionOneItems + sectionTwoItems)
    let completeListOfIndexPaths = (sectionOneIndexPaths + sectionTwoIndexPaths)
    
    sidebarView.insertSidebarView(models: completeListOfItems, atIndexPaths: completeListOfIndexPaths)
    
    
    
    
    // Create ReusableView View-Models
    
    let reusableSectionItems: [SidebarViewReusableViewSectionModel] = // ... Construct array of ReusableView Section View-Models
    let sectionIndices: [Int] = // ... Construct of section indices (positive integers)
    
    sidebarView.insertReusableView(reusableSectionModels: reusableSectionItems, atIndices: sectionIndices)
    
}

```


<br />

<h3>Extending the SidebarViewDelegate</h3>

<p>You may extend the class:</p>

```swift
class ViewController: SidebarViewDelegate {

    func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath) {
        
        // Provide custom action/functionality when tapping a SidebarView cell at each indexPath
        
    }
    
    func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat {
        
        // Provide height for supplementary header reusableView at each section
        
    }
    
    func sidebarView(_ sidebarView: SidebarView, heightForFooterIn section: Int) -> CGFloat {
        
        // Provide height for supplementary footer reusableView at each section
        
    }
    
    func sidebarView(_ view: SidebarView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        
        // Provide heights for items at each IndexPath
        
    }
}
```





## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ModularSidebarView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ModularSidebarView'
```

## Author

ChrishonWyllie, chrishon595@yahoo.com

## License

ModularSidebarView is available under the MIT license. See the LICENSE file for more info.

