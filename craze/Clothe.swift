//
//  Clothe.swift
//  craze
//
//  Created by Jeremy Broutin on 11/1/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Clothe)

class Clothe: NSManagedObject {
  
  struct Keys {
    static let SeasonKey = "season"
    static let CategoryKey = "category"
    static let ColorKey = "color"
    static let Style = "style"
    static let ImageData = "ImageData"
    static let PreviouslyUsed = "previouslyUsed"
  }
  
  @NSManaged var season: String?
  @NSManaged var category: String?
  @NSManaged var color: String?
  @NSManaged var style: String?
  @NSManaged var imageData: NSData?
  @NSManaged var previouslyUsed: NSDate?
  @NSManaged var outfits: NSSet?
  
  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }
  
  init(dictionary: [String: Any], context: NSManagedObjectContext){
    let entity = NSEntityDescription.entityForName("Clothe", inManagedObjectContext: context)
    super.init(entity: entity!, insertIntoManagedObjectContext: context)
    
    season = dictionary[Keys.SeasonKey] as? String
    category = dictionary[Keys.CategoryKey] as? String
    color = dictionary[Keys.ColorKey] as? String
    style = dictionary[Keys.Style] as? String
    imageData = dictionary[Keys.ImageData] as? NSData
    if let date = dictionary[Keys.PreviouslyUsed] as? NSDate {
      previouslyUsed = date
    }
    outfits = NSSet?()
  }
}