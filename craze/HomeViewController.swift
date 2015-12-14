//
//  HomeViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 10/18/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

let weatherNotificationKey = "com.foobar.weatherNotificationKey"

class HomeViewController: UIViewController, CLLocationManagerDelegate {
  
  // Properties
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var mainWeatherLabel: UILabel!
  @IBOutlet weak var weatherIconImage: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageTop: UIImageView!
  @IBOutlet weak var refreshButtonShadow: UIButton!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var validateButton: UIButton!
  @IBOutlet weak var refreshTopButton: UIButton!
  @IBOutlet weak var topActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var pantsActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var shoesActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var imagePants: UIImageView!
  @IBOutlet weak var imageShoes: UIImageView!
  
  // dispatching queues
  var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
  }
  var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
  }
  var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
  }
  var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
  }
  var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
  }
  
  // stored clothe for outfit validation
  var recoTop: Clothe?
  var recoPants: Clothe?
  var recoShoes: Clothe?
  
  // variables
  var colorToUseInBackground: UIColor?
  var currentLocation: CLLocationCoordinate2D?
  var storedWeather: WeatherInfo?
  var isWeatherInfoAvailable: Bool! = false
  
  // constants
  let userDefaults = NSUserDefaults.standardUserDefaults() //instance for user defaults
  let locationManager = CLLocationManager() //get location to get weather
  let constantsFile = GlobalConstants() //instance for constants file
  let gradientTopView = CAGradientLayer().redPinkColor() // gradient layer
  
  // Core data context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext
  }
  
  /************************************ Mark: - App life cycle *************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI STUFF
    // force proper positioning of scroll view programmatically
    self.automaticallyAdjustsScrollViewInsets = false
    // gradient color on top view
    topView.layer.insertSublayer(self.gradientTopView, atIndex: 0)
    
    // drop shadows
    topView.layer.shadowOpacity = 0.5
    topView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    refreshButtonShadow.layer.shadowOpacity = 0.5
    refreshButtonShadow.layer.shadowOffset = CGSize(width: 0.2, height: 1.0)
    // disable validate outfit
    validateButton.hidden = true
    
    // Ask for Authorisation from the User to use its location
    self.locationManager.requestAlwaysAuthorization()
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      // set accuracy to km to limit necessary power
      locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
      locationManager.distanceFilter = 10000 //in meters
      locationManager.startUpdatingLocation()
    }
    
    // Set the navigation
    if colorToUseInBackground == nil {
      colorToUseInBackground = view.backgroundColor
    }
    NavigationController.sharedInstance().setNavBar(self)
    
    // Receive weather info
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "runReco", name: weatherNotificationKey, object: nil)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.gradientTopView.frame = topView.bounds
  }

  /************************************ Mark: - Helper functions *************************************/
  
   // manually turn on location manager
  func turnOnLocationManager(){
    locationManager.startUpdatingLocation()
  }
   
   // Load weather info into UI elements
  func loadWeatherInfo(weather: WeatherInfo?) {
    if let weather = weather {
      
      // debug printing - delete before going live
      print("temperature is: \(weather.temperature)")
      print("main weather is: \(weather.weatherMain)")
      
      // set the tempLabel value with weather info
      self.tempLabel.hidden = false
      self.tempLabel.text = NSString(format:"%.1f°C", weather.temperature) as String
      
      // check the weatherMain value to set the background image accordingly
      switch weather.weatherMain{
        case "Clear":
          setUIWithColor(constantsFile.YellowSun, imageName: constantsFile.sunIcon, weatherLabelIndex: constantsFile.sunLabelIndex)
        case "Clouds", "Mist", "Fog", "Haze":
          setUIWithColor(constantsFile.DarkBlueCloud, imageName: constantsFile.cloudIcon, weatherLabelIndex: constantsFile.cloudLabelIndex)
        case "Rain", "Drizzle":
          setUIWithColor(constantsFile.PurpleRain, imageName: constantsFile.rainIcon , weatherLabelIndex: constantsFile.rainLabelIndex)
      case "Snow":
        setUIWithColor(constantsFile.GreySnow, imageName: constantsFile.snowIcon, weatherLabelIndex: constantsFile.snowLabelIndex)
      default:
        setUIWithColor(constantsFile.BlueDefault, imageName: constantsFile.noWeatherIcon, weatherLabelIndex: constantsFile.noSongLabelIndex)
      }
    }
  }
  
  // Set UI
  func setUIWithColor(color: UIColor, imageName: String, weatherLabelIndex: Int){
    //self.topView.backgroundColor = color /* replaced by app gradient color*/
    self.weatherIconImage.image = UIImage(named: imageName)
    self.mainWeatherLabel.text = constantsFile.mainWeatherLabelValues[weatherLabelIndex]
  }
  
  // Mark the weather info as available (not used in the code right now)
  func markWeatherAsAvailable(){
    isWeatherInfoAvailable = true
  }
  
  // Load recommendations
  func runReco() {
    // Show users that the images are loading
    topActivityIndicator.hidden = false
    topActivityIndicator.startAnimating()
    pantsActivityIndicator.hidden = false
    pantsActivityIndicator.startAnimating()
    shoesActivityIndicator.hidden = false
    shoesActivityIndicator.startAnimating()
    
    // Load recommendations and display images based on results
    dispatch_async(GlobalUserInteractiveQueue){
      RecoEngine.sharedInstance().runRecoEngineBis(self.storedWeather) { selectedTop, selectedPants, selectedShoes, error in
        if let top = selectedTop {
          self.recoTop = top
          dispatch_async(self.GlobalMainQueue){
            self.imageTop.image = UIImage(data: top.imageData!)
            self.topActivityIndicator.stopAnimating()
          }
        } else {
          self.recoTop = nil
          self.loadDefaultImage(self.imageTop, activityIndicator: self.topActivityIndicator)
        }
        if let pants = selectedPants {
          self.recoPants = pants
          dispatch_async(self.GlobalMainQueue){
            self.imagePants.image = UIImage(data: pants.imageData!)
            self.pantsActivityIndicator.stopAnimating()
          }
        } else {
          self.recoPants = nil
          self.loadDefaultImage(self.imagePants, activityIndicator: self.pantsActivityIndicator)
        }
        if let shoes = selectedShoes {
          self.recoShoes = shoes
          dispatch_async(self.GlobalMainQueue){
            self.imageShoes.image = UIImage(data: shoes.imageData!)
            self.shoesActivityIndicator.stopAnimating()
          }
        } else {
          self.recoShoes = nil
          self.loadDefaultImage(self.imageShoes, activityIndicator: self.shoesActivityIndicator)
        }
      }
      self.enableOrDisableValidateButton()
    }
  }
  
  // load/dispatch default image placeholder and stop the activity indicator
  func loadDefaultImage(imageView: UIImageView, activityIndicator: UIActivityIndicatorView){
    dispatch_async(self.GlobalMainQueue){
      imageView.image = UIImage(named: "no-match-found")
      activityIndicator.stopAnimating()
    }
  }
  
  // check if all three clothes var holders are not nil to enable validate button
  func enableOrDisableValidateButton() {
    if recoTop != nil && recoPants != nil && recoShoes != nil {
      dispatch_async(self.GlobalMainQueue){
        self.validateButton.hidden = false
      }
    } else {
      dispatch_async(self.GlobalMainQueue){
        self.validateButton.hidden = true
      }
    }
  }

  
  
  /************************************ Mark: - IBActions ******************************************/
  
   // TODO: concatenate the 3 individual refreshes in a single function
   
   // refresh the top clothe only
  @IBAction func refreshTopTapped(sender: AnyObject) {
    imageTop.image = UIImage(named: "imagePlaceHolder")
    topActivityIndicator.hidden = false
    topActivityIndicator.startAnimating()
    dispatch_async(GlobalUserInitiatedQueue){
      RecoEngine.sharedInstance().selectTop(self.storedWeather){ result, error in
        if let top = result {
          self.recoTop = top
          dispatch_async(self.GlobalMainQueue){
            self.imageTop.image = UIImage(data: top.imageData!)
            self.topActivityIndicator.stopAnimating()
          }
        } else if let _ = error {
          dispatch_async(self.GlobalMainQueue){
            print("Error when refreshing top")
            self.loadDefaultImage(self.imageTop, activityIndicator: self.topActivityIndicator)
            self.topActivityIndicator.stopAnimating()
          }
        }
      }
      self.enableOrDisableValidateButton()
    }
  }
  
  // refresh the pants clothe only
  @IBAction func refreshPantsTapped(sender: AnyObject) {
    imagePants.image = UIImage(named: "imagePlaceHolder")
    pantsActivityIndicator.hidden = false
    pantsActivityIndicator.startAnimating()
    dispatch_async(GlobalUserInitiatedQueue){
      RecoEngine.sharedInstance().selectPantsOrShoes(["Pants", "Jeans", "Legging", "Skirt", "Jogging"], weather: self.storedWeather, topToMatch: self.recoTop, pantsToMatch: nil){ result, error in
        if let pants = result {
          self.recoPants = pants
          dispatch_async(self.GlobalMainQueue){
            self.imagePants.image = UIImage(data: pants.imageData!)
            self.pantsActivityIndicator.stopAnimating()
          }
        } else if let _ = error {
          dispatch_async(self.GlobalMainQueue){
            print("Error when refreshing pants")
            self.loadDefaultImage(self.imagePants, activityIndicator: self.pantsActivityIndicator)
            self.pantsActivityIndicator.stopAnimating()
          }
        }
      }
      self.enableOrDisableValidateButton()
    }
  }
  
  // refresh the shoes clothe only
  @IBAction func refreshShoesTapped(sender: AnyObject) {
    imageShoes.image = UIImage(named: "imagePlaceHolder")
    shoesActivityIndicator.hidden = false
    shoesActivityIndicator.startAnimating()
    dispatch_async(GlobalUserInitiatedQueue){
      RecoEngine.sharedInstance().selectPantsOrShoes(["Shoes", "Boots", "Sneakers"], weather: self.storedWeather, topToMatch: self.recoTop, pantsToMatch: self.recoPants){ result, error in
        if let shoes = result {
          self.recoShoes = shoes
          dispatch_async(self.GlobalMainQueue){
            self.imageShoes.image = UIImage(data: shoes.imageData!)
            self.shoesActivityIndicator.stopAnimating()
          }
        } else if let _ = error {
          dispatch_async(self.GlobalMainQueue){
            print("Error when refreshing shoes")
            self.loadDefaultImage(self.imageShoes, activityIndicator: self.shoesActivityIndicator)
            self.shoesActivityIndicator.stopAnimating()
          }
        }
      }
      self.enableOrDisableValidateButton()
    }
  }
  
  // Validate outfit
  @IBAction func validateOutfit(sender: AnyObject) {
    // set the name
    let name = ""
    // set the date
    let dateForOutfit = NSDate()
    // create a new Outfit object
    let outfit = Outfit(outfitName: name, outfitDate: dateForOutfit, topClothe: recoTop!, pantsClothe: recoPants!, shoesClothe: recoShoes!, context: sharedContext)
    print("outfit created: \(outfit)")
    CoreDataStackManager.sharedInstance().saveContext()
    // confirm the validation to the user
    let alertController = UIAlertController(title: constantsFile.validateAlertTitle, message: constantsFile.validateAlertMessage, preferredStyle: constantsFile.validateAlertStyle)
    let firstAction = UIAlertAction(title: constantsFile.validateFirstActionTitle, style: constantsFile.validateFirstActionStyle){(action) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    alertController.addAction(firstAction)
    let secondAction = UIAlertAction(title: constantsFile.validateSecondActionTitle, style: constantsFile.validateSecondActionStyle){ (action) in
      let controller = self.storyboard?.instantiateViewControllerWithIdentifier("tableView")
      self.dismissViewControllerAnimated(true, completion: nil)
      self.navigationController?.pushViewController(controller!, animated: true)
    }
    alertController.addAction(secondAction)
    presentViewController(alertController, animated: true, completion: nil)
    //disable the validate button until next recommendation
    validateButton.hidden = true
  }
  
  
  // Refresh selection
  @IBAction func refreshSelection(sender: AnyObject) {
    self.refreshButton.rotate360Degrees()
    runReco()
    enableOrDisableValidateButton()
  }

  
  
  /***************************** Mark: - CoreLocation Delegate methods ******************************/
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locationArray = locations as NSArray
    let locationObj = locationArray.lastObject as! CLLocation
    currentLocation = locationObj.coordinate
    print("coordinates are: \(currentLocation!.latitude), \(currentLocation!.longitude)")
    
    if currentLocation != nil {
      dispatch_async(GlobalUserInteractiveQueue) {
        OWM_Client.sharedInstance().getWeatherInfo(self.currentLocation!.latitude, lon: self.currentLocation!.longitude) { success, weather, error in
          dispatch_async(dispatch_get_main_queue(), {
            // inform the class that the weather info is now available
            self.isWeatherInfoAvailable = true
            self.storedWeather = weather
            // notify the app so that it can run the recommendation
            NSNotificationCenter.defaultCenter().postNotificationName(weatherNotificationKey, object: self)
            // update UI based on wather info
            self.loadWeatherInfo(weather)
          })
        }
      }
    }
    // add a timer to prevent the location to update for 60min (6000sec)
    locationManager.stopUpdatingLocation()
    NSTimer.scheduledTimerWithTimeInterval(6000, target: self, selector: "turnOnLocationManager", userInfo: nil, repeats: false)

  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    self.weatherIconImage.image = UIImage(named: "no-weather")
    self.colorToUseInBackground = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
    NavigationController.sharedInstance().setNavBar(self)
    self.mainWeatherLabel.text = constantsFile.mainWeatherLabelValues[constantsFile.noSongLabelIndex]
  }
  
}