//
//  OutfitsTableViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/24/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OutfitsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  // Constants and variables
  let navigationTitle = "Your outfits history"
  private let reuseIdentifier = "OutfitCell"
  // Core Data Context
  var sharedContext: NSManagedObjectContext{
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  // Lazy initialization of fetchedresultsController
  lazy var fetchedResultsController: NSFetchedResultsController = {
    
    let fetchRequest = NSFetchRequest(entityName: "Outfit")
    fetchRequest.sortDescriptors = []
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: self.sharedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  
  /*********************************** Mark: - App Life Cycle *****************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI STUFF
    self.navigationItem.title = navigationTitle
    self.navigationItem.rightBarButtonItem = editButtonItem()
    self.tableView.rowHeight = 76.0
    
    // Perform initial fetch
    fetchedResultsController.delegate = self
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    
    // If there are no images associated with the pin, show label to user and disable newCollectionButton
    if fetchedResultsController.fetchedObjects?.count == 0 {
      // TODO: display no content view
    }
    
    // reload table data post fetch
    tableView.reloadData()
    
    // Register custom cell
    let nib = UINib(nibName: "OutfitCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "OutfitCell")
  }
  
  /******************************* Mark: - TableView Data Source methods ******************************/
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.fetchedObjects!.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! OutfitCellTableViewCell
    // get an oufit using the cell indexPath
    let outfit = fetchedResultsController.objectAtIndexPath(indexPath) as! Outfit
    // pass necessary information to the custom cell class
    cell.receivedOutfit = outfit
    if outfit.name == "" {
      cell.outfitName.text = "Unnamed - Tap to edit"
    } else {
      cell.outfitName.text = outfit.name
    }
    if let outfitImageTop = outfit.imageTop {
      cell.imageTop.image = UIImage(data: outfitImageTop)
    }
    if let outfitImagePants = outfit.imagePants {
      cell.imagePants.image = UIImage(data: outfitImagePants)
    }
    if let outfitImageShoes = outfit.imageShoes {
      cell.imageShoes.image = UIImage(data: outfitImageShoes)
    }
    cell.dateOutfit.text = "" + NSDateFormatter.localizedStringFromDate(outfit.date!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    // return the custom cell
    return cell
  }
  
  /******************************* Mark: - TableView Delegate methods *********************************/
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      // delete the outfit object from core data
      sharedContext.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as! Outfit)
      do {
        try sharedContext.save()
      } catch{
        //Do something with error
      }
    }
  }
  
  /******************************* Mark: - NSFetchedResults Delegate methods *********************************/
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type{
    case NSFetchedResultsChangeType.Delete:
      tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as! [NSIndexPath], withRowAnimation: .Fade)
    default:
      break
    }
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    tableView.endUpdates()
  }
  
}
