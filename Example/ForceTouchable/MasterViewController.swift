//
//  MasterViewController.swift
//  ForceTouchable
//
//  Created by Ivan Bruel on 01/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ForceTouchable
import UIKit

class MasterViewController: UITableViewController {
  // MARK: Types

  /// A simple data structure to populate the table view.
  struct PreviewDetail {
    let title: String
    let preferredHeight: Double
  }

  // MARK: Properties

  let sampleData = [
    PreviewDetail(title: "Small", preferredHeight: 160.0),
    PreviewDetail(title: "Medium", preferredHeight: 320.0),
    PreviewDetail(title: "Large", preferredHeight: 0.0) // 0.0 to get the default height.
  ]

  /// An alert controller used to notify the user if 3D touch is not available.
  var alertController: UIAlertController?

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewWillAppear(animated: Bool) {
    // Clear the selection if the split view is only showing one view controller.
    clearsSelectionOnViewWillAppear = splitViewController!.collapsed

    super.viewWillAppear(animated)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupForceTouch()

    // Present the alert if necessary.
    if let alertController = alertController {
      alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      presentViewController(alertController, animated: true, completion: nil)

      // Clear the `alertController` to ensure it's not presented multiple times.
      self.alertController = nil
    }
  }

  // MARK: UIStoryboardSegue Handling

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail", let indexPath = tableView.indexPathForSelectedRow {
      let previewDetail = sampleData[indexPath.row]

      let detailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController

      // Pass the `title` to the `detailViewController`.
      detailViewController.detailItemTitle = previewDetail.title
    }
  }

  // MARK: Table View

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of items in the sample data structure.
    return sampleData.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

    let previewDetail = sampleData[indexPath.row]
    cell.textLabel!.text = previewDetail.title

    return cell
  }
}

// MARK: ForceTouchable
extension MasterViewController: ForceTouchable {

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

