//
//  OutfitCellTableViewCell.swift
//  craze
//
//  Created by Jeremy Broutin on 11/24/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OutfitCellTableViewCell: UITableViewCell, UITextFieldDelegate {

  @IBOutlet weak var imageTop: UIImageView!
  @IBOutlet weak var imagePants: UIImageView!
  @IBOutlet weak var imageShoes: UIImageView!
  @IBOutlet weak var dateOutfit: UILabel!
  @IBOutlet weak var outfitName: UITextField!
  
  var receivedOutfit: Outfit?
  let defaultOutfitName = "Unnamed - Tap to edit"
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      outfitName.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  /********************* Mark: - TextField Delegate methods ***********************/
  
  func textFieldDidBeginEditing(textField: UITextField) {
    // delete text only if no previous name was given
    if textField.text == self.defaultOutfitName {
      textField.text = nil
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.text != nil && textField.text != defaultOutfitName {
      receivedOutfit!.name = textField.text
      do{
        try sharedContext.save()
      } catch{
        // Do something with the throw
        print("could not save the updated outfit name")
      }
    } else if textField.text == nil {
      textField.text = defaultOutfitName
    }
    textField.resignFirstResponder()
    return true
  }
  
  /************************ Mark: - Core Data Context ****************************/
  
  var sharedContext: NSManagedObjectContext{
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }

}
