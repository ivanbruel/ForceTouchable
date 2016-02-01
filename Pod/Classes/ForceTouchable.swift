//
//  ForceTouchable.swift
//  ChicByChoice
//
//  Created by Ivan Bruel on 01/02/16.
//  Copyright © 2016 Chic by Choice. All rights reserved.
//

import Foundation
import UIKit

/**
 *  ForceTouchable requires a few functions from UIViewController's class to work, such as 
 *  a traitCollection, a view and a few functions related to peek and pop.
 */
public protocol ForceTouchable: AnyObject {

  var view: UIView! { get }
  var traitCollection: UITraitCollection { get }

  var forceTouchDelegate: ForceTouchDelegate? { get set }

  func forceTouchPreviewForLocation(location: CGPoint) -> ForceTouchPreview?
  func registerForPreviewingWithDelegate(delegate: UIViewControllerPreviewingDelegate,
    sourceView: UIView) -> UIViewControllerPreviewing
  func showViewController(vc: UIViewController, sender: AnyObject?)
}

/**
 *  Struct for returning the force touched view and the view controller to be previewed.
 */
public struct ForceTouchPreview {
  public let touchedView: UIView
  public let previewViewController: UIViewController

  public init(previewViewController: UIViewController, touchedView: UIView) {
    self.touchedView = touchedView
    self.previewViewController = previewViewController
  }
}

/// Key for adding property to UIViewController
private var forceTouchDelegateKey: UInt8 = 0

/// ForceTouchable extension for UIViewController, setupForceTouch() creates and sets a
/// ForceTouchDelegate as UIViewController property.
public extension ForceTouchable where Self: UIViewController {

  public var forceTouchDelegate: ForceTouchDelegate? {
    get {
      return objc_getAssociatedObject(self, &forceTouchDelegateKey) as? ForceTouchDelegate
    }
    set {
      objc_setAssociatedObject(self, &forceTouchDelegateKey, newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    }
  }

  public func setupForceTouch() {
    self.forceTouchDelegate = ForceTouchDelegate(forceTouchable: self)
  }

}

/// An out-of-the-box UIViewControllerPreviewingDelegate implementation which depends
/// on a UIViewController for sanity checks and pushing view controllers, and a ForceTouchable
/// implementation to get the previewViewController and the force touched view.
public class ForceTouchDelegate: NSObject, UIViewControllerPreviewingDelegate {

  public let forceTouchable: ForceTouchable

  public init(forceTouchable: ForceTouchable) {
    self.forceTouchable = forceTouchable

    super.init()

    if forceTouchable.traitCollection.forceTouchCapability == .Available {
      forceTouchable.registerForPreviewingWithDelegate(self, sourceView: forceTouchable.view)
    }
  }

  public func previewingContext(previewingContext: UIViewControllerPreviewing,
    viewControllerForLocation location: CGPoint) -> UIViewController? {

      guard let forceTouchPreview = forceTouchable.forceTouchPreviewForLocation(location) else {
        return nil
      }

      forceTouchPreview.previewViewController.preferredContentSize = CGSize.zero
      previewingContext.sourceRect = forceTouchPreview.touchedView.frame

      return forceTouchPreview.previewViewController
  }

  public func previewingContext(previewingContext: UIViewControllerPreviewing,
    commitViewController viewControllerToCommit: UIViewController) {
      forceTouchable.showViewController(viewControllerToCommit, sender: self)
  }

}
