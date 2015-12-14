//
//  Outfit.swift
//  craze
//
//  Created by Jeremy Broutin on 11/24/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Outfit)

class Outfit: NSManagedObject {
  
  /*struct Keys {
    static let name = "name"
    static let Date = "date"
    static let ImageTop = "imageTop"
    static let ImagePants = "imagePants"
    static let ImageShoes = "imageShoes"
  }*/
  
  @NSManaged var name: String?
  @NSManaged var date: NSDate?
  @NSManaged var imageTop: NSData?
  @NSManaged var imagePants: NSData?
  @NSManaged var imageShoes: NSData?
  @NSManaged var clothes: NSSet?
  
  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  init(outfitName: String, outfitDate: NSDate, topClothe: Clothe, pantsClothe: Clothe, shoesClothe: Clothe, context: NSManagedObjectContext){
    let entity = NSEntityDescription.entityForName("Outfit", inManagedObjectContext: context)
    super.init(entity: entity!, insertIntoManagedObjectContext: context)
    
    name = outfitName
    date = outfitDate
    imageTop = topClothe.imageData
    imagePants = pantsClothe.imageData
    imageShoes = shoesClothe.imageData
    clothes = NSSet().setByAddingObjectsFromArray([topClothe, pantsClothe, shoesClothe])
    
  }
}
