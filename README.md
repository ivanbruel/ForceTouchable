# ForceTouchable

[![Version](https://img.shields.io/cocoapods/v/ForceTouchable.svg?style=flat)](http://cocoapods.org/pods/ForceTouchable)
[![License](https://img.shields.io/cocoapods/l/ForceTouchable.svg?style=flat)](http://cocoapods.org/pods/ForceTouchable)
[![Platform](https://img.shields.io/cocoapods/p/ForceTouchable.svg?style=flat)](http://cocoapods.org/pods/ForceTouchable)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ForceTouchable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ForceTouchable"
```

## Usage

To use ForceTouchable on your UIViewControllers all you have to do is implement the ForceTouchable protocol.
Most methods are already implemented in case your ForceTouchable implementation is a UIViewController, all you need to implement is `forceTouchPreviewForLocation(CGPoint)` and call `setupForceTouch()` on your `viewDidAppear` method.

```swift
// MARK: ForceTouchable
extension ViewController: ForceTouchable {

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupForceTouch()
  }

  func forceTouchPreviewForLocation(location: CGPoint) -> ForceTouchPreview? {
    guard let indexPath = tableView.indexPathForRowAtPoint(location),
      cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }

    // Create a detail view controller and set its properties.
    guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController else { return nil }

    let previewDetail = sampleData[indexPath.row]
    detailViewController.detailItemTitle = previewDetail.title

    return ForceTouchPreview(previewViewController: detailViewController, touchedView: cell)
  }

}
```

## Author

Ivan Bruel, ivan.bruel@gmail.com

## License

ForceTouchable is available under the MIT license. See the LICENSE file for more info.
