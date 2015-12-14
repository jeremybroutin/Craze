//
//  GlobalConstants.swift
//  foobar
//
//  Created by Jeremy Broutin on 12/4/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class GlobalConstants: NSObject {
  
  /* Constants */
  
  // All pages constants
  // clothe categories color (thin color line under pictures)
  let LightOrangeColor = UIColor(red:0.98, green:0.72, blue:0.14, alpha:1.0)
  let LightPinkColor = UIColor(red:0.95, green:0.43, blue:0.49, alpha:1.0)
  let LightTurquoiseColor = UIColor(red:0.19, green:0.77, blue:0.60, alpha:1.0)
  
  // Home page constants
  // home page top view background colors
  let YellowSun = UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.0)
  let DarkBlueCloud = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
  let PurpleRain /*lol*/ = UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.0)
  let GreySnow = UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0)
  let BlueDefault = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
  // home page weather icons
  let sunIcon = "sun-thick"
  let cloudIcon = "cloud-thick"
  let rainIcon = "rain-thick"
  let snowIcon = "snow-thick"
  let noWeatherIcon = "no-weather"
  // home page weather quotes/songs indexes
  let sunLabelIndex: Int = 0
  let cloudLabelIndex: Int = 1
  let rainLabelIndex: Int = 2
  let snowLabelIndex: Int = 3
  let noSongLabelIndex: Int = 4
  // home page weather quotes/songs values
  let mainWeatherLabelValues = [
    "Let the Sun Shine",
    "Get Off of My Cloud",
    "Singin' in the Rain",
    "Let It Snow! Let It Snow! Let It Snow!",
    "No weather song :("
  ]
  // validation of the recommendation
  let validateAlertStyle: UIAlertControllerStyle = .Alert
  let validateAlertTitle = "Great!"
  let validateAlertMessage = "We are glad you liked the proposed outfit! \nFind it in your Outfit history"
  let validateFirstActionTitle = "OK"
  let validateFirstActionStyle: UIAlertActionStyle = .Default
  let validateSecondActionTitle = "Go to my outfits"
  let validateSecondActionStyle: UIAlertActionStyle = .Default
  
  // Edit page constants
  // categories Arrays
  let categoryArray = ["Top", "Pullover", "Sweater", "Hoodie", "T-shirt", "Dress", "Pants", "Jeans", "Legging", "Skirt", "Jogging", "Shoes", "Boots", "Sneakers"]
  let seasonArray = ["All", "Winter", "Spring", "Summer", "Fall"]
  let colorArray = ["Black", "Blue", "Brown", "Grey", "Green", "Orange", "Red", "Violet", "White", "Yellow"]
  let styleArray = ["Casual: Day in a Life, Go to work", "Fancy: Dress to Impress, Night out, Suit up", "Sport: Time for exercice, or Lazy day"]
  // constant strings
  let selectCatValue = "select category"
  let selectSeasonValue = "select season"
  let selectColorValue = "select main color"
  let selectStyleValue = "select style"
  let congratsAlertTitle = "Saved!"
  let congratsAlertMessage = "Your new clothe has been added to your closet!"
  let congratsAlertAction = "OK"
  
  // edit image alert view To be outsourced in separate class)
  let addAlertTitle = "Add a new outfit from:"
  let addAlertMessage = "Select your option"
  let cameraActionTitle = "Camera"
  let galleryActionTitle = "Photo Gallery"
  let deleteAlertTitle = "Warning"
  let deleteAlertMessage = "Do you really want to delete this clothe?"
  
  
  /* MARK: - Shared Instance */
  
  class func sharedInstance() -> GlobalConstants {
    struct Singleton {
      static var sharedInstance = GlobalConstants()
    }
    return Singleton.sharedInstance
  }
  
}