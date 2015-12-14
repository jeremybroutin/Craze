//
//  DetailViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/12/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit


class DetailViewController: UIViewController {
  
  @IBOutlet weak var clotheImagePlaceHolder: UIImageView!
  @IBOutlet weak var categoryKey: UILabel!
  @IBOutlet weak var categoryValue: UILabel!
  @IBOutlet weak var seasonKey: UILabel!
  @IBOutlet weak var seasonValue: UILabel!
  @IBOutlet weak var colorKey: UILabel!
  @IBOutlet weak var colorsValue: UILabel!
  @IBOutlet weak var styleKey: UILabel!
  @IBOutlet weak var styleValue: UILabel!
  @IBOutlet weak var clotheDetailsView: UIView!
  
  @IBOutlet weak var colorLineView: UIView!
  @IBOutlet weak var errorMessageLabel: UILabel!
  
  var colorOfImageLine: UIColor?
  
  var clothe: Clothe!
  
  /* Mark: - App life cycle */
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set the navigation bar item: Edit
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "openEditVC")
    editButton.enabled = false
    self.navigationItem.rightBarButtonItem = editButton
    
    // Set background color based on clothe category
    colorLineView.backgroundColor = colorOfImageLine
    categoryKey.textColor = colorOfImageLine
    seasonKey.textColor = colorOfImageLine
    colorKey.textColor = colorOfImageLine
    styleKey.textColor = colorOfImageLine
    
    // verify that we could load the clothe object
    if let clothe = clothe {
      // enable the edit button
      editButton.enabled = true
      // load clothe attributes
      clotheImagePlaceHolder.image = UIImage(data: clothe.imageData!)
      categoryValue.text = clothe.category
      seasonValue.text = clothe.season
      colorsValue.text = clothe.color
      styleValue.text = clothe.style
    } else {
      // otherwise show error message
      clotheDetailsView.hidden = true
      errorMessageLabel.text = "Sorry, we couldn't get the clothe details \n Try editing it"
      errorMessageLabel.hidden = false
    }
    
  }
  
  /* Mark: - Utility functions */
  
  func openEditVC(){
    let controller = storyboard?.instantiateViewControllerWithIdentifier("addClotheTer") as! EditViewController
    controller.receivedClothe = clothe
    let navController = UINavigationController(rootViewController: controller)
    presentViewController(navController, animated: true, completion: nil)
    
    // TODO: it takes the user to the creation flow
    // It does not EDIT the EXISTING OBJECTS
    // Probably safer to go to a new view controller for EDITION
    
  }
  
}