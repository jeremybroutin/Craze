//
//  RecoEngine.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/18/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import CoreData

class RecoEngine: NSObject, NSFetchedResultsControllerDelegate {
   
  // Core data context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  
  /* Shared session */
  
  var session: NSURLSession

  override init() {
    session = NSURLSession.sharedSession()
    super.init()
  }
  
  /* MARK: - Shared Instance */
  
  class func sharedInstance() -> RecoEngine {
    struct Singleton {
      static var sharedInstance = RecoEngine()
    }
    return Singleton.sharedInstance
  }
  
    
  /* Mark: - Helper functions */
  
  // HOUR OF THE DAY: get the current hour of the day when function is called
  func getHourOfTheDay() -> Int {
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Hour), fromDate: date)
    let hour = components.hour
    return hour
  }
  
  // MONTH OF THE YEAR: getthe current month
  func getMonthOfTheYear() -> Int {
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month), fromDate: date)
    let month = components.hour
    return month
  }
  
  // SEASON: get the array of seasons based on the temperature
  func getSeasonsFromTemperature(temp: Float) -> [String]{
    var seasonToBePicked = [String]()
    if temp < 8 {
      seasonToBePicked = [Seasons.winter, Seasons.all]
    } else if temp >= 8 && temp < 25 {
      seasonToBePicked = [Seasons.spring, Seasons.fall, Seasons.all]
      /*let month = getMonthOfTheYear()
      if month < 6 {
        seasonToBePicked = [Seasons.spring, Seasons.all]
      } else if month >= 6 {
        seasonToBePicked = [Seasons.fall, Seasons.all]
      } else {
        print("Top/The resulting month: \(month) did not fit any of the conditions")
      }*/
    } else if temp >= 25 {
      seasonToBePicked = [Seasons.summer, Seasons.all]
    } else {
      print("Top/The resulting temperature: \(temp) did not fit any of the conditions")
    }
    return seasonToBePicked
  }
  
  // STYLE: get the style based on the hour of the day
  func getStylesFromHour(hour: Int) -> [String]{
    var styleToBePicked = [String]()
    if hour < 7 {
      styleToBePicked.append(Styles.casual)
      styleToBePicked.append(Styles.sport)
    } else if (hour >= 7 && hour < 18) {
      styleToBePicked.append(Styles.casual)
    } else if hour >= 18 && hour < 20 {
      styleToBePicked.append(Styles.casual)
      styleToBePicked.append(Styles.sport)
    } else if hour >= 20 {
      styleToBePicked.append(Styles.fancy)
    } else {
      print("The resulting hour: \(hour) didn't fit the available conditions")
    }
    return styleToBePicked
  }
  
  // FETCH: trigger the fetch and select clothe from results
  func fetchDataAndSelectClothe(compoundPredicate: NSCompoundPredicate, completionHandler:(success: Bool, selectedClothe: Clothe?, error: NSError?) -> Void){
    
    let fetchRequest = NSFetchRequest(entityName: "Clothe")
    fetchRequest.predicate = compoundPredicate
    fetchRequest.sortDescriptors = []
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: self.sharedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    // if we didn't get any data
    if fetchedResultsController.fetchedObjects?.count == 0 {
      print("There is no clothe to fetch or that matches the predicates in Core Data")
      completionHandler(success: false, selectedClothe: nil, error: NSError(domain: "FetchedResultsController", code: 0, userInfo: [NSLocalizedDescriptionKey: "There was no matching fetched Objects"]))
    }
      // if we did get data
    else {
      print("Success, there are: \(fetchedResultsController.fetchedObjects?.count) clothes in Core Data")
      // store the number of items available
      let numberOfItems = fetchedResultsController.fetchedObjects?.count
      // get a random index in the limit of the number of objects available
      let randomIndex = Int.random(0..<numberOfItems!)
      // select random clothe from available option
      let selectedClothe = fetchedResultsController.fetchedObjects![randomIndex] as! Clothe
      completionHandler(success: true, selectedClothe: selectedClothe, error: nil)
    }
  }
  
}


// Extension of the Int object to create a "random" function
extension Int
{
  static func random(range: Range<Int> ) -> Int
  {
    let offset = 0
    let mini = UInt32(range.startIndex + offset)
    let maxi = UInt32(range.endIndex   + offset)
    
    return Int(mini + arc4random_uniform(maxi - mini)) - offset
  }
}