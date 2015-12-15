//
//  RecoEngine_Convenience.swift
//  craze
//
//  Created by Jeremy Broutin on 11/23/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension RecoEngine {
  
  
  /* MARK: - Run the algorithm */
  
  func runRecoEngineBis(weather: WeatherInfo?, completionHandler:(selectedTop: Clothe?, selectedPants: Clothe?, selectedShoes: Clothe?, error: NSError?) -> Void){
    
    // set variables to use in completionHandler
    var topFound: Clothe!
    var pantsFound: Clothe!
    var shoesFound: Clothe!
    
    // look for a top
    selectTop(weather){ result, error in
      if let top = result {
        topFound = top
      } else if let _ = error {
        print("top error in selectTop - Reco Eng Conv.")
      }
    }
    // look for pants
    selectPantsOrShoes(Categories.allPantsCategories, weather: weather, topToMatch: topFound, pantsToMatch: nil){ result, error in
      if let pants = result {
        pantsFound = pants
      } else if let _ = error {
        print("pants error in selectTop - Reco Eng Conv.")
      }
    }
    // look for shoes
    selectPantsOrShoes(Categories.allShoescategories, weather: weather, topToMatch: topFound, pantsToMatch: pantsFound) { result, error in
      if let shoes = result {
        shoesFound = shoes
      } else if let _ = error {
        print("shoes error in selectTop - Reco Eng Conv.")
      }
    }
    // fill in completionHandler
    completionHandler(selectedTop: topFound, selectedPants: pantsFound, selectedShoes: shoesFound, error: nil)
    
    
  }
  
  
  /* MARK: - Algo convenience methods */
  
  /********************** PART 1 ******************************/
  
  func selectTop(weather: WeatherInfo?, completionHandler:(result: Clothe?, error: NSError?)-> Void){
    let hour = getHourOfTheDay()
    var stylesToBePicked = [String]()
    var seasonsToBePicked = [String]()
    var categoriesToBePicked = [String]()
    var predicateSeason: NSPredicate?
    var compoundPredicate: NSCompoundPredicate!
    
    //1- based on the time of the day, pick a style
    let stylesArray = getStylesFromHour(hour)
    stylesToBePicked.appendContentsOf(stylesArray)
    
    //2 - based on the weather or temperature, pick a season
    if let weather = weather {
      let temp = weather.temperature
      seasonsToBePicked = getSeasonsFromTemperature(temp)
      predicateSeason = NSPredicate(format: Constants.seasonPredicateFormat, seasonsToBePicked)
    } else{
      print("RecoEngine - select Top: couldnt get the weather info")
      seasonsToBePicked.append("none")
    }
    
    //3 - get date of the day to pick close worn more than 3 days ago
    let date = NSDate()
    // set the previousDate to be 3 days before today
    let userCalendar = NSCalendar.currentCalendar()
    let periodComponents = NSDateComponents()
    periodComponents.day = -3
    let previousDate = userCalendar.dateByAddingComponents(periodComponents, toDate: date, options: [])!
    
    //4 - set the category
    categoriesToBePicked = Categories.allTopCategories
    
    //5 - create predicates and compound predicate for fetch request
    
    let predicateStyle = NSPredicate(format: Constants.stylePredicateFormat, stylesToBePicked)
    let predicateLastUsed = NSPredicate(format: Constants.datePredicateFormat, previousDate)
    let predicateCategory = NSPredicate(format: Constants.categoryPredicateFormat, categoriesToBePicked)
    // if we have the weather and so the season, we include it in our filters
    if let infoSeason = predicateSeason{
      compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [infoSeason, predicateStyle, predicateLastUsed, predicateCategory])
    } else {
      // if not we just skip
       compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateStyle, predicateLastUsed, predicateCategory])
    }
    
    
    //6 - fetch the data accordingly
    fetchDataAndSelectClothe(compoundPredicate){ success, selectedClothe, error in
      if success {
        completionHandler(result: selectedClothe, error: nil)
        print("Top found for season:\(seasonsToBePicked), style:\(stylesToBePicked) ")
      } else {
        if let topError = error {
          // TODO: display an error to the user to inform the top couldn't find
          completionHandler(result: nil, error: topError)
        }
      }
    }
  }
  
  /********************** PART 2 ******************************/
  
  func selectPantsOrShoes(categories: [String], weather: WeatherInfo?, topToMatch:Clothe?, pantsToMatch: Clothe?, completionHandler:(result: Clothe?, error: NSError?)-> Void){
    // Constants and variables
    let hour = getHourOfTheDay()
    var seasonsToBePicked = [String]()
    var stylesToBePicked = [String]()
    var colorsToBePicked = [String]()
    
    // Prepare predicates
    var predicateSeason: NSPredicate!
    var predicateStyle: NSPredicate!
    var predicateColor: NSPredicate!
    var predicateCategory: NSPredicate!
    var predicateLastUsed: NSPredicate!
    
    // IF TOP IS AVAILABLE: USE MATCHING CONDITIONS
    if let top = topToMatch {
      //1- select season
      // 1.a - if the top season is all, check temperature
      if top.season! == Seasons.all {
        if let weather = weather {
          let temp = weather.temperature
          seasonsToBePicked = getSeasonsFromTemperature(temp)
        } else {
          print("RecoEngine - select Pants: couldnt get the weather info")
          seasonsToBePicked += ([Seasons.all, Seasons.winter, Seasons.fall, Seasons.spring, Seasons.summer])
        }
      }
      // 1.b - if not, pick the top season and "all"
      else {
        seasonsToBePicked.append(top.season!)
        seasonsToBePicked.append(Seasons.all)
      }
      predicateSeason = NSPredicate(format: Constants.seasonPredicateFormat, seasonsToBePicked)
      
      //2- select style to match top.style
      stylesToBePicked.append(top.style!)
      predicateStyle = NSPredicate(format: Constants.stylePredicateFormat, stylesToBePicked)
      
      //3- select colors to match top color compatibility
      let topColor = top.color
      // Note: for pants, we choose the color based on the top only
      if categories == Categories.allPantsCategories {
        switch (topColor!) {
        case "Black":
          colorsToBePicked = Constants.blackCompatibility
        case "Brown":
          colorsToBePicked = Constants.brownCompatibility
        case "Red":
          colorsToBePicked = Constants.redCompatibility
        case "Orange":
          colorsToBePicked = Constants.orangeCompatibility
        case "Yellow":
          colorsToBePicked = Constants.yellowCompatibility
        case "Green":
          colorsToBePicked = Constants.greenCompatibility
        case "Blue":
          colorsToBePicked = Constants.blueCompatibility
        case "Violet":
          colorsToBePicked = Constants.violetCompatibility
        default:
          break
        }
      }
      // Note: for shoes, we choose the color based on top and pants
      else if categories == Categories.allShoescategories {
        if let pants = pantsToMatch {
          let pantsColor = pants.color
          colorsToBePicked = [topColor!, pantsColor!, "Black"]
        }
      }
      predicateColor = NSPredicate(format: Constants.colorPredicateFormat, colorsToBePicked)
    }
      
    // IF NO TOP IS AVAILABLE: USE ONLY WEATHER AND HOUR OF THE DAY
    else {
      //1- select season based on weather
      if let weather = weather {
        let temp = weather.temperature
        seasonsToBePicked = getSeasonsFromTemperature(temp)
        predicateSeason = NSPredicate(format: Constants.seasonPredicateFormat, seasonsToBePicked)
      } else{
        print("RecoEngine - select Pants: couldnt get the weather info")
      }
      //2- select style based on hour of the day
      let stylesArray = getStylesFromHour(hour)
      stylesToBePicked.appendContentsOf(stylesArray)
      predicateStyle = NSPredicate(format: Constants.stylePredicateFormat, stylesToBePicked)
    }
    
    //4- select clothe last used date to be <3 days or nil
    // Note: only for pants as shoes can be wore several days in a row
    let date = NSDate()
    let userCalendar = NSCalendar.currentCalendar()
    let periodComponents = NSDateComponents()
    if categories == Categories.allPantsCategories {
      periodComponents.day = -3
    }
    let previousDate = userCalendar.dateByAddingComponents(periodComponents, toDate: date, options: [])!
    predicateLastUsed = NSPredicate(format: Constants.datePredicateFormat, previousDate)
    
    //5- select category (fixed value)
    let categoriesToBePicked = categories
    predicateCategory = NSPredicate(format: Constants.categoryPredicateFormat, categoriesToBePicked)
    
    //6- create compoundPredicate with all predicates
    var compoundPredicate: NSCompoundPredicate!
    if colorsToBePicked.isEmpty{
      compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSeason, predicateStyle, predicateLastUsed, predicateCategory])
    } else {
      compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSeason, predicateStyle, predicateColor, predicateLastUsed, predicateCategory])
    }
    
    //7- fetch the proper data thanks to the compoundPredicate
    fetchDataAndSelectClothe(compoundPredicate) { success, selectedClothe, error in
      if success {
        completionHandler(result: selectedClothe, error: nil)
        print("\(categories) found for season:\(seasonsToBePicked), style:\(stylesToBePicked) ")
      } else if let pantsError = error {
        // TODO: print an error or is it already handled by the function?
        // set a placeholder image and inform user the selection could not be completed
        // UILabel probably a good option
        print("\(categories) NOT found for season:\(seasonsToBePicked), style:\(stylesToBePicked), color:\(colorsToBePicked)")
        completionHandler(result: nil, error: pantsError)
      }
    }
    
  }
  
}