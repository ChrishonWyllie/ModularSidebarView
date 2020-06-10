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
    // Either initializer is fine
    // let sbv = SidebarView(delegate: self, dismissesOnSelection: true)
    // let sbv = SidebarView(delegate: self, dismissesOnSelection: true, pushesRootOnDisplay: false)
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
<ul>
    <li><p>Simply tap the background view</p></li>
    <li><p>Or pressing one of the options in the SidebarView will also dismiss on selection if set to TRUE in initializer</p></li>
</ul>




<h3>Customizing the SidebarView</h3>
<p>The ModularSidebarView relies on a variety of Delegate functions in order to provide a customizable look</p>

<br />

<h3>Customizing using the SidebarViewDelegate</h3>

<p>You may extend the class:</p>

```swift
class ViewController: UIViewController, SidebarViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // ....
    }


    // Conform to SidebarViewDelegate here...
    // NOTE
    // There are many optional delegate functions, 
    // but most of them are similar to UICollectionViewDataSource and UICollectionViewDelegate


    // Example
    // Providing your own custom Sidebar cell
    
    func registerCustomCellForSidebarView() -> AnyClass {
        return CustomSidebarCell.self
    }
    
    func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        if let customCell = cell as? CustomSidebarCell {
        
            // Do custom UI setup for cell
        }
        
    }
}
```


## SidebarViewDelegate
<p>Use these delegate functions to configure the Sidebar as you see fit</p>

```swift

// MARK: - Configure SidebarView

func numberOfSections(in sidebarView: SidebarView) -> Int

func sidebarView(_ sidebarView: SidebarView, numberOfItemsInSection section: Int) -> Int

// Use this to provide an action to when a cell is selected. Similar to UITableView or UICollectionView functionality
@objc optional func sidebarView(_ sidebarView: SidebarView, didSelectItemAt indexPath: IndexPath)

// For settings specific colors for each item manually instead of blanket coloring every cell
@objc optional func sidebarView(backgroundColor color: UIColor, forItemAt IndexPath: IndexPath) -> UIColor

// Determine width of SidebarView using percentage of device screen. Default is 0.80 (80 %) of the screen
@objc optional var sidebarViewWidth: CGFloat { get }

// Determine background color of the SidebarView
@objc optional var sidebarViewBackgroundColor: UIColor { get }

// Determine color of the "blur" view in the background. Essentially the darkening effect that appears over the unerlying viewcontroller
@objc optional var backgroundColor: UIColor { get }

// Determine the style of the "blur" view. Options: .dark, .light, .extraLight
@objc optional var blurBackgroundStyle: UIBlurEffectStyle { get }

// Determine whether the SidebarView will push the underlying rootViewController over when displayed
// or simply Cover it
@objc optional var shouldPushRootViewControllerOnDisplay: Bool { get }

// Round the topRight and bottomRight corners of the SidebarView
@objc optional func shouldRoundCornersWithRadius() -> CGFloat

// Allow users to swipe to the right in order to display the SidebarView
@objc optional var allowsPullToDisplay: Bool { get }



// MARK: - Configure Headers

@objc optional func willDisplayHeaders() -> Bool

// Provide your own view to be added to the Header in each section of the SidebarView
@objc optional func sidebarView(_ sidebarView: SidebarView, viewForHeaderIn section: Int) -> UIView?

// Configure the height of each header
@objc optional func sidebarView(_ sidebarView: SidebarView, heightForHeaderIn section: Int) -> CGFloat








// MARK: - Configure Cells

// For creating custom cells. Return your own UICollectionViewCell class to be registered
// Although the function requires an 'AnyClass', it must be a UICollectionViewCell in order to be registered
@objc optional func registerCustomCellForSidebarView() -> AnyClass

// Provide custom configurations for your custom cell
@objc optional func sidebarView(configureCell cell: UICollectionViewCell, forItemAt indexPath: IndexPath)

// Determine background color of the SidebarViewCell
@objc optional var sidebarCellBackgroundColor: UIColor { get }

// Determine the actual title of each UICollectionViewCell
func sidebarView(titlesForItemsIn section: Int) -> [String]



// !!!
// These three optional delegate functions work for the DEFAULT SidebarViewCell. If you provide a custom cell, don't use these

// Font of UILabel in SidebarViewCell
@objc optional func sidebarView(fontForTitleAt indexPath: IndexPath) -> UIFont?

// TextColor of UILabel in SidebarViewCell
@objc optional func sidebarView(textColorForTitleAt indexPath: IndexPath) -> UIColor?

// Determine height of each cell
@objc optional func sidebarView(heightForItemIn section: Int) -> CGFloat


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

