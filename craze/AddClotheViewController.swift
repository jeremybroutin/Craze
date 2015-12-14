//
//  AddClotheViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/9/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddClotheViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet weak var clotheImageView: UIImageView!
  @IBOutlet weak var navlabel: UILabel!
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var previousButton: UIButton!
  
  var imageAdded: UIImage?
  var colorToUseInBackground: UIColor?
  //var token: String?
  let initialArray = ["Top", "Pants", "Shoes"]
  let secondArray = ["Winter", "Spring", "Summer", "Fall"]
  let thirdArray = ["Black", "Blue", "Brown", "Grey", "Orange", "Red", "White", "Yellow"]
  let fourthArray = ["Casual", "Fancy", "Sport", "Work"]
  var arrayInProgress = []
  var step = 1
  
  var elementValue: String!
  var seasonValue: String!
  var colorValue: String!
  var styleValue: String!
  
  /* Mark: - Core Data Context */
  var sharedContext: NSManagedObjectContext{
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.delegate = self
    // load the image selected by the user
    clotheImageView.image = imageAdded!
    // load the picker array with the first set of values
    arrayInProgress = initialArray
    // disable the next button by default
    nextButton.enabled = false
    nextButton.backgroundColor = UIColor.grayColor()
    
  }
  
  /* Mark: - IBActions*/
  
  // tap on Cancel top right item
  @IBAction func tapCancelButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // tap on Next button
  @IBAction func goToNextStep(sender: AnyObject) {
    switch step{
    case 1:
      // update the array with next set of values
      arrayInProgress = secondArray
      // reload the picker view
      self.pickerView.reloadAllComponents()
      // disable the next button (until next picker didSelect...)
      nextButton.enabled = false
      nextButton.backgroundColor = UIColor.grayColor()
      // change the section title
      navlabel.text = "Choose a season"
      // increment the step
      step += 1
    case 2:
      arrayInProgress = thirdArray
      self.pickerView.reloadAllComponents()
      nextButton.enabled = false
      nextButton.backgroundColor = UIColor.grayColor()
      navlabel.text = "Select the dominant color"
      step += 1
    case 3:
      arrayInProgress = fourthArray
      self.pickerView.reloadAllComponents()
      nextButton.enabled = false
      nextButton.backgroundColor = UIColor.grayColor()
      navlabel.text = "Choose a style"
      nextButton.setTitle("SAVE NOW", forState: .Normal)
      step += 1
    case 4:
      let imageData = UIImageJPEGRepresentation(imageAdded!, 1.0)
      let dict:[String: Any]  = [
        Clothe.Keys.SeasonKey: seasonValue!,
        Clothe.Keys.CategoryKey: elementValue!,
        Clothe.Keys.ColorKey: colorValue!,
        Clothe.Keys.Style: styleValue!,
        Clothe.Keys.ImageData: imageData!
      ]
      _ = Clothe(dictionary: dict, context: sharedContext)
      CoreDataStackManager.sharedInstance().saveContext()
      
      // display confirmation of clothe added
      let alertController = UIAlertController(title: "Congratulations", message: "Your new outfit has been added to your closet!", preferredStyle: .Alert)
      let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (action) in
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
      }
      alertController.addAction(action)
      self.presentViewController(alertController, animated: true, completion: nil)
    default: break
      
    }
  }

  
  /* UIPickerView Delegate methods*/
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrayInProgress.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(arrayInProgress[row])"
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    nextButton.enabled = true
    nextButton.backgroundColor = UIColor(red: 0.9686, green: 0.3608, blue: 0.6353, alpha: 1.0)
    switch step{
    case 1:
      elementValue = arrayInProgress[row] as? String
    case 2:
      seasonValue = arrayInProgress[row] as? String
    case 3:
      colorValue = arrayInProgress[row] as? String
    case 4:
      styleValue = arrayInProgress[row] as? String
    default: break
    }
  }

}
