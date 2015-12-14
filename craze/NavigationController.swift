//
//  NavigationController.swift
//  DressMeUp
//
//  Created by Jeremy Broutin on 8/3/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var view: UIViewController!
  let addAlertTitle = "Add a new outfit from:"
  let addAlertMessage = "Select your option"
  let cameraActionTitle = "Camera"
  let galleryActionTitle = "Photo Gallery"
  
  /* MARK: - SET NAV */
  
  // Helper function to create nav UIBarButtonItem
  func createEl(imageName: String, actionName: Selector) -> UIBarButtonItem {
    let navEl: UIButton = UIButton(type: UIButtonType.Custom)
    navEl.frame = CGRectMake(0, 0, 30, 30)
    navEl.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    navEl.addTarget(self, action: actionName, forControlEvents: UIControlEvents.TouchUpInside)
    let navElItem: UIBarButtonItem = UIBarButtonItem(customView: navEl)
    return navElItem
  }
  
  func addSeparation() -> UIBarButtonItem {
    let separator: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
    return separator
  }
  
  // Set the navigation bar
  func setNavBar(viewController: UIViewController) {
    view = viewController
    
    // set selectors actions (modify here)
    // let homeSelector: Selector = "homeLogoClicked:"
    let collectionSelector: Selector = "accessCollection:"
    let tableSelector: Selector = "accessTable:"
    let addClotheSelector: Selector = "accessAddClothe:"
    
    // set up the nav elements (do not modify)
    let separator = addSeparation()
    let collectionButton = createEl("wardrobe", actionName: collectionSelector)
    let tableButton = createEl("history", actionName: tableSelector)
    let addClotheButton = createEl("plus", actionName: addClotheSelector)
    
    viewController.navigationItem.leftBarButtonItems = [collectionButton, separator, tableButton]
    viewController.navigationItem.rightBarButtonItems = [addClotheButton]
  }
  
  /* MARK: - NAV ITEMS INTERACTIONS */
  
  func accessCollection(sender:UIButton){
    let controller = self.view!.storyboard?.instantiateViewControllerWithIdentifier("collectionView") as! CollectionViewController
    self.view!.navigationController?.pushViewController(controller, animated: true)
  }
  
  func accessTable(sender: UIButton){
    let controller = self.view!.storyboard?.instantiateViewControllerWithIdentifier("tableView") as! OutfitsTableViewController
    self.view!.navigationController?.pushViewController(controller, animated: true)
  }
  
  func accessAddClothe(sender: UIButton) {
    let alertController = UIAlertController(title: addAlertTitle, message: nil, preferredStyle: .ActionSheet)
    // Cancel
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    // Use Camera
    let cameraAction = UIAlertAction(title: cameraActionTitle, style: .Default){ (action) in
      // insert function to open camera
      self.addElementOptions(self.cameraActionTitle)
    }
    alertController.addAction(cameraAction)
    // Open Photo Gallery
    let galleryAction = UIAlertAction(title: galleryActionTitle, style: .Default) {(action) in
      // insert function to open gallery
      self.addElementOptions(self.galleryActionTitle)
    }
    alertController.addAction(galleryAction)
    self.view!.presentViewController(alertController, animated: true, completion: nil)
  }

  // Helper function for the AddClothe action
  func addElementOptions(option: String) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    if option == cameraActionTitle {
      pickerController.sourceType = .Camera
      pickerController.cameraCaptureMode = .Photo
    }
    else if option == galleryActionTitle{
      pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    self.view!.presentViewController(pickerController, animated: true, completion: nil)
  }
  
  
  /* Mark: - UIImagePickerController Delegate methods*/
  
  //deal with selected image or taken picture
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
    // take the user to the AddClothe view to add clothes info and save it to core data
    let controller = self.view!.storyboard?.instantiateViewControllerWithIdentifier("editClothe") as! EditViewController
    controller.imageAdded = image
    let navController = UINavigationController(rootViewController: controller)
    self.view!.dismissViewControllerAnimated(true, completion: nil)
    self.view!.presentViewController(navController, animated: true, completion: nil)
    
  }
  
  //present the cancel option for the imagePickerController
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.view!.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // MARK: - Shared Instance
  class func sharedInstance() -> NavigationController {
    struct Singleton {
      static var sharedInstance = NavigationController()
    }
    return Singleton.sharedInstance
  }
}
