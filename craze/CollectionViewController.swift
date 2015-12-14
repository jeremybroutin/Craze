//
//  CollectionViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 10/23/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, NSFetchedResultsControllerDelegate, ModalTransitionListener {
  

  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var topImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var noItemImage: UIImageView!
  @IBOutlet weak var noItemTitle: UILabel!
  @IBOutlet weak var noItemAction: UIButton!
  @IBOutlet weak var noItemView: UIView!
  
  let navigationBarTitle = "Your closet"
  var refreshCollection: Bool = false
  var colorToUseInBackground: UIColor?
  
  // Cell identifier
  private let reuseIdentifier = "ClotheCell"
  
  // Core data context
  var sharedContext: NSManagedObjectContext{
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  
  /*********************************** Mark: - App Life Cycle ****************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI STUFF
    self.navigationItem.title = navigationBarTitle
    self.collectionView.backgroundColor = UIColor.clearColor()
    // Add Plus button in nav
    let addClotheSelector: Selector = "addClothe"
    let navEl: UIButton = UIButton(type: UIButtonType.Custom)
    navEl.frame = CGRectMake(0, 0, 30, 30)
    navEl.setImage(UIImage(named: "plus"), forState: UIControlState.Normal)
    navEl.addTarget(self, action: addClotheSelector, forControlEvents: UIControlEvents.TouchUpInside)
    let navElItem: UIBarButtonItem = UIBarButtonItem(customView: navEl)
    navigationItem.rightBarButtonItem = navElItem
    // add drop shadow on closet image
    topView.layer.shadowOpacity = 0.5
    topView.layer.shadowOffset = CGSizeMake(0, 2)
    
    // Set Listener for Modal View (EditClotheView)
    ModalTransitionMediator.sharedInstance().setListener(self)
    
    // Register custom cell
    let nib = UINib(nibName: "ClotheCell", bundle: nil)
    collectionView.registerNib(nib, forCellWithReuseIdentifier: "clotheCell")
    
    // Fetch data
    fetchedResultsController.delegate = self
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    print("fetch results count is: \(fetchedResultsController.fetchedObjects?.count)")
    if fetchedResultsController.fetchedObjects?.count == 0 {
      // display no item message
      collectionView.hidden = true
      noItemView.hidden = false
      noItemImage.hidden = false
      noItemTitle.hidden = false
      noItemAction.hidden = false

    }
    
    // Set the collection delegate and data source
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    //Layout the collectionView cells properly on the View
    let layout = UICollectionViewFlowLayout()
    
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 5
    layout.minimumInteritemSpacing = 5
    
    let width = (floor(self.collectionView.frame.size.width / 3)) - 7
    layout.itemSize = CGSize(width: width, height: width)
    
    collectionView.collectionViewLayout = layout
  }
  
  /************************************* Mark: - IBActions *******************************************/
  
  @IBAction func addClotheNow(sender: AnyObject) {
    self.addClothe()
  }
  
  /********************************** Mark: - Helper functions ***************************************/
   
  func addClothe(){
    let controller = storyboard?.instantiateViewControllerWithIdentifier("editClothe") as! EditViewController
    let navController = UINavigationController(rootViewController: controller)
    presentViewController(navController, animated: true, completion: nil)
  }
  
  /************************ Mark: - ModalMediatorTransitionListener Delegate *************************/
   
  func popoverDismissed() {
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    collectionView.reloadData()
    if fetchedResultsController.fetchedObjects?.count > 0{
      noItemView.hidden = true
      collectionView.hidden = false
    } else {
      noItemView.hidden = false
      collectionView.hidden = true
    }
    
  }

  /********************************** Mark: - Data Source methods ************************************/
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultsController.sections![section]
    //print("numberOfItems: \(sectionInfo.numberOfObjects)")
    return sectionInfo.numberOfObjects
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("clotheCell", forIndexPath: indexPath) as! ClotheCell
    let clothe = fetchedResultsController.objectAtIndexPath(indexPath) as! Clothe
    cell.clotheImageView.image = UIImage(data: clothe.imageData!)
    switch (clothe.category!){
      case "Top", "Pullover", "Sweater", "Hoodie", "T-shirt", "Dress":
      cell.colorLine.backgroundColor = UIColor(red:0.19, green:0.77, blue:0.60, alpha:1.0)
      case "Pants", "Jeans", "Legging", "Skirt", "Jogging":
      cell.colorLine.backgroundColor = UIColor(red:0.95, green:0.43, blue:0.49, alpha:1.0)
      case "Shoes", "Boots", "Sneakers":
      cell.colorLine.backgroundColor = UIColor(red:0.98, green:0.72, blue:0.14, alpha:1.0)
    default:
      break
    }
    return cell
  }
  
  /*********************** Mark: - CollectionViewController Delegate methods *************************/
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let clothe = fetchedResultsController.objectAtIndexPath(indexPath) as! Clothe
    let controller = storyboard?.instantiateViewControllerWithIdentifier("editClothe") as! EditViewController
    controller.receivedClothe = clothe
    let navController = UINavigationController(rootViewController: controller)
    presentViewController(navController, animated: true, completion: nil)
  }
  
  /******************************** Mark: - Fetch Results Controller *********************************/
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    
    let fetchRequest = NSFetchRequest(entityName: "Clothe")
    fetchRequest.sortDescriptors = []
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: self.sharedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    return fetchedResultsController
    
    }()
  
  /******************************** Mark: - Singleton/Shared Instance ********************************/

  class func sharedInstance() -> CollectionViewController {
    struct Singleton {
      static var sharedInstance = CollectionViewController()
    }
    return Singleton.sharedInstance
  }
  
}
