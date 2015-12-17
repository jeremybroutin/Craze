//
//  EditClotheViewController.swift
//  craze
//
//  Created by Jeremy Broutin on 12/2/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {
  
  // Properties
  @IBOutlet weak var clotheImageView: UIImageView!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var editImageButton: UIButton!
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var categoryKey: UILabel!
  @IBOutlet weak var selectCategoryButton: UIButton!
  @IBOutlet weak var editCategoryButton: UIButton!
  @IBOutlet weak var seasonKey: UILabel!
  @IBOutlet weak var selectSeasonButton: UIButton!
  @IBOutlet weak var editSeasonButton: UIButton!
  @IBOutlet weak var colorKey: UILabel!
  @IBOutlet weak var selectColorButton: UIButton!
  @IBOutlet weak var editColorButton: UIButton!
  @IBOutlet weak var styleKey: UILabel!
  @IBOutlet weak var selectStyleButton: UIButton!
  @IBOutlet weak var editStyleButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  // create an instance of the global constants class
  let constantsFile = GlobalConstants()
  
  // Variables
  // received from previous view
  var imageAdded: UIImage?
  var receivedClothe: Clothe?
  var editExistingObject = false
  // global variable for save button
  var saveButton: UIBarButtonItem?
  // booleans for SAVE evaluation
  var didSelectCat: Bool?
  var didSelectSeason: Bool?
  var didSelectColor: Bool?
  var didSelectStyle: Bool?
  // holders for Core Data object
  var clotheCategory: String!
  var clotheSeason: String!
  var clotheColor: String!
  var clotheStyle: String!
  // instatiate an array for picker view
  var arrayPickerView = [String]()
  
  // Get Core data context
  var sharedContext: NSManagedObjectContext{
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  
  /*********************************** Mark: - App Life Cycle *********************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set the picker view delegate
    pickerView.delegate = self
    
    // check if we are creating a new clothe or editing an existing one
    // if yes, load the existing clothe info
    if let clotheToUpdate = receivedClothe {
      editExistingObject = true
      deleteButton.hidden = false
      // set the UI properties accordingly
      clotheImageView.image = UIImage(data:clotheToUpdate.imageData!)
      updateColorView(clotheToUpdate.category!)
      selectCategoryButton.setTitle(clotheToUpdate.category, forState: .Normal)
      selectSeasonButton.setTitle(clotheToUpdate.season, forState: .Normal)
      selectColorButton.setTitle(clotheToUpdate.color, forState: .Normal)
      selectStyleButton.setTitle(clotheToUpdate.style, forState: .Normal)
      // set the core data holders
      clotheCategory = clotheToUpdate.category
      clotheSeason = clotheToUpdate.season
      clotheColor = clotheToUpdate.color
      clotheStyle = clotheToUpdate.style
      //unhide all edit buttons
      editCategoryButton.hidden = false
      editSeasonButton.hidden = false
      editColorButton.hidden = false
      editStyleButton.hidden = false
    }
    // if not, check if we have an imageAdded
    else if let image = imageAdded {
      clotheImageView.image = image
    }
    // otherwise load nothing
    
    // set navigation items
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonPressed:")
    saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    saveButton!.enabled = false
    self.navigationItem.leftBarButtonItem = cancelButton
    self.navigationItem.rightBarButtonItem = saveButton
    
    // evaluate values of attributes to enable save button or not
    if selectCategoryButton.titleLabel!.text != constantsFile.selectCatValue && selectSeasonButton.titleLabel!.text != constantsFile.selectSeasonValue && selectColorButton.titleLabel!.text != constantsFile.selectColorValue && selectStyleButton.titleLabel!.text != constantsFile.selectStyleValue {
      saveButton!.enabled = true
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    ModalTransitionMediator.sharedInstance().sendPopoverDismissed(true)
  }
  
  /*********************************** Mark: - IBActions *********************************************/

  @IBAction func selectCategoryTapped(sender: UIButton) {
    arrayPickerView = constantsFile.categoryArray
    pickerView.reloadAllComponents()
    pickerView.hidden = false
    doneButton.hidden = false
  }
  
  @IBAction func selectSeasonTapped(sender: UIButton) {
    arrayPickerView = constantsFile.seasonArray
    pickerView.reloadAllComponents()
    pickerView.hidden = false
    doneButton.hidden = false
  }
  
  @IBAction func selectColorTapped(sender: UIButton) {
    arrayPickerView = constantsFile.colorArray
    pickerView.reloadAllComponents()
    pickerView.hidden = false
    doneButton.hidden = false
    print("sender title: \(sender.titleLabel)")
  }
  
  @IBAction func selectStyleTapped(sender: UIButton) {
    arrayPickerView = constantsFile.styleArray
    pickerView.reloadAllComponents()
    pickerView.hidden = false
    doneButton.hidden = false
  }
  
  @IBAction func doneButtonTapped(sender: UIButton) {
    doneButton.hidden = true
    pickerView.hidden = true
    
    // enable the save button if all attributes have a user defined value
    if imageAdded != nil && selectCategoryButton.titleLabel!.text != constantsFile.selectCatValue && selectSeasonButton.titleLabel!.text != constantsFile.selectSeasonValue && selectColorButton.titleLabel!.text != constantsFile.selectColorValue && selectStyleButton.titleLabel!.text != constantsFile.selectStyleValue {
      saveButton!.enabled = true
    }
  }
  
  @IBAction func editImageButtonTapped(sender: UIButton) {
    let alertController = UIAlertController(title: constantsFile.addAlertTitle, message: nil, preferredStyle: .ActionSheet)
    // Cancel
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    // Use Camera
    let cameraAction = UIAlertAction(title: constantsFile.cameraActionTitle, style: .Default){ (action) in
      // insert function to open camera
      self.addElementOptions(self.constantsFile.cameraActionTitle)
    }
    // disable Camera button click if not available
    if !UIImagePickerController.isSourceTypeAvailable(.Camera){
      cameraAction.enabled = false
    }
    alertController.addAction(cameraAction)
    // Open Photo Gallery
    let galleryAction = UIAlertAction(title: constantsFile.galleryActionTitle, style: .Default) {(action) in
      // insert function to open gallery
      self.addElementOptions(self.constantsFile.galleryActionTitle)
    }
    alertController.addAction(galleryAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func deleteButtonTapped(sender: UIButton) {
    let alertController = UIAlertController(title: constantsFile.deleteAlertTitle, message: constantsFile.deleteAlertMessage, preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive){ (action) in
      // delete object
      self.deleteClothe()
      // return to collection view (dismiss editVC)
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    alertController.addAction(confirmAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  /*************************** Mark: - UIPickerView Delegate methods ********************************/
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrayPickerView.count
  }
  
  func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
    let pickerLabel = UILabel()
    pickerLabel.text = arrayPickerView[row]
    pickerLabel.font = UIFont(name: "Helvetica Neue", size: 15)
    pickerLabel.textAlignment = NSTextAlignment.Center
    return pickerLabel
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if arrayPickerView == constantsFile.categoryArray {
      selectCategoryButton.setTitle(arrayPickerView[row], forState: .Normal)
      editCategoryButton.hidden = false
      clotheCategory = arrayPickerView[row]
      updateColorView(clotheCategory)
    } else if arrayPickerView == constantsFile.seasonArray {
      selectSeasonButton.setTitle(arrayPickerView[row], forState: .Normal)
      editSeasonButton.hidden = false
      clotheSeason = arrayPickerView[row]
    } else if arrayPickerView == constantsFile.colorArray {
      selectColorButton.setTitle(arrayPickerView[row], forState: .Normal)
      editColorButton.hidden = false
      clotheColor = arrayPickerView[row]
    } else if arrayPickerView == constantsFile.styleArray {
      selectStyleButton.setTitle(arrayPickerView[row], forState: .Normal)
      editStyleButton.hidden = false
      clotheStyle = arrayPickerView[row]
    }
  }
  
  /*************************** Mark: - UIImagePicker Delegate methods ********************************/
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.imageAdded = image
    clotheImageView.image = image
    // enable the save button if all attributes have a user defined value
    if imageAdded != nil && selectCategoryButton.titleLabel!.text != constantsFile.selectCatValue && selectSeasonButton.titleLabel!.text != constantsFile.selectSeasonValue && selectColorButton.titleLabel!.text != constantsFile.selectColorValue && selectStyleButton.titleLabel!.text != constantsFile.selectStyleValue {
      saveButton!.enabled = true
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /********************************** Mark: - Helper functions ***************************************/
  
  // cancel function for leftBarButtonItem in nav
  func cancelButtonPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // save function for rightBarButtonItem in nav
  func saveButtonPressed(sender: UIBarButtonItem){
    // include condition to simply save modification for existing object
    if editExistingObject {
      // save edited clothe
      receivedClothe?.category = clotheCategory
      receivedClothe?.season = clotheSeason
      receivedClothe?.color = clotheColor
      receivedClothe?.style = clotheStyle
      receivedClothe?.imageData = UIImageJPEGRepresentation(clotheImageView.image!, 1.0)
      
    } else {
      // create a Clothe Object from dictionary
      let imageData = UIImageJPEGRepresentation(clotheImageView.image!, 1.0)
      let dict:[String: Any]  = [
        Clothe.Keys.CategoryKey: clotheCategory!,
        Clothe.Keys.SeasonKey: clotheSeason!,
        Clothe.Keys.ColorKey: clotheColor!,
        Clothe.Keys.Style: clotheStyle!,
        Clothe.Keys.ImageData: imageData!
      ]
      let clothe = Clothe(dictionary: dict, context: sharedContext)
      print("Saved clothe is: \(clothe)")
    }
    // save core data (either new object or edited one)
    do{
      try sharedContext.save()
    } catch{
      // TODO: do something in response to error condition
    }
    
    // display confirmation of clothe added
    let alertController = UIAlertController(title: constantsFile.congratsAlertTitle, message: constantsFile.congratsAlertMessage, preferredStyle: .Alert)
    let action = UIAlertAction(title: constantsFile.congratsAlertAction, style: UIAlertActionStyle.Default){ (action) in
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
      
    }
    alertController.addAction(action)
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  // set Camera or Gallery actions for the UIImagePickerViewController
  func addElementOptions(option: String) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    if option == constantsFile.cameraActionTitle {
      pickerController.sourceType = .Camera
      pickerController.cameraCaptureMode = .Photo
    }
    else if option == constantsFile.galleryActionTitle {
      pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    presentViewController(pickerController, animated: true, completion: nil)
  }
  
  // change the color of the colorVie wline below the image
  func updateColorView(category: String){
    switch (category){
    case "Top", "Pullover", "Sweater", "Hoodie", "T-shirt", "Dress":
      colorView.backgroundColor = constantsFile.LightTurquoiseColor
    case "Pants", "Jeans", "Legging", "Skirt", "Jogging":
      colorView.backgroundColor = constantsFile.LightPinkColor
    case "Shoes", "Boots", "Sneakers":
      colorView.backgroundColor = constantsFile.LightOrangeColor
    default:
      break
    }
  }
  
  // delete object from core data
  func deleteClothe(){
    if let existingClothe = receivedClothe {
      self.sharedContext.deleteObject(existingClothe)
    }
    do{
      try sharedContext.save()
    } catch{
      // Do something in response to error condition
      print("could not delete the object")
    }
  }
  
  
}
