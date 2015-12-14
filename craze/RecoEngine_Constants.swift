//
//  RecoEngine_Constants.swift
//  craze
//
//  Created by Jeremy Broutin on 11/23/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation


extension RecoEngine {
  
  struct Constants {
    static let redCompatibility = ["Orange", "Violet", "Black", "White", "Blue"]
    static let blackCompatibility = ["Black", "Blue", "Brown", "Green", "Gray", "Yellow", "Orange", "Violet", "White"]
    static let brownCompatibility = ["White", "Red", "Black", "White"]
    static let blueCompatibility = ["Green", "Violet", "Black", "White", "Gray","Red"]
    static let orangeCompatibility = ["Red", "Green", "Black", "White"]
    static let greenCompatibility = ["Yellow", "Blue", "Black", "White"]
    static let yellowCompatibility = ["Orange", "Green", "White"]
    static let violetCompatibility = ["Blue", "Red", "White"]
    static let grayCompatibility = ["Red", "White", "Black","Blue"]
    static let whiteCompatibility = ["Black", "Blue", "Brown", "Green", "Yellow", "Orange", "Violet", "White"]
    
    static let seasonPredicateFormat = "season IN %@"
    static let stylePredicateFormat = "style IN %@"
    static let colorPredicateFormat = "color IN %@"
    static let datePredicateFormat = "previouslyUsed >= %@ OR previouslyUsed = nil"
    static let categoryPredicateFormat = "category IN %@"
  }
  
  struct Categories {
    static let allTopCategories = ["Top", "Pullover", "Sweater", "Hoodie", "T-shirt", "Dress"]
    static let allPantsCategories = ["Pants", "Jeans", "Legging", "Skirt", "Jogging"]
    static let allShoescategories = ["Shoes", "Boots", "Sneakers"]
  }
  
  struct Styles {
    static let casual = "Casual: Day in a Life, Go to work"
    //static let work = "Work"
    static let sport = "Sport: Time for exercice, or Lazy day"
    static let fancy = "Fancy: Dress to Impress, Night out, Suit up"
  }
  
  struct Seasons {
    static let winter = "Winter"
    static let spring = "Spring"
    static let summer = "Summer"
    static let fall = "Fall"
    static let all = "All"
  }
  
}