//
//  LogoViewController.swift
//  craze
//
//  Created by Jeremy Broutin on 12/12/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
  
  let userDefaults = NSUserDefaults.standardUserDefaults() //instance for user defaults
  
  var pageViewController: UIPageViewController!
  var pageTitles: NSArray!
  var pageImages: NSArray!
  var pageTexts: NSArray!
  
  let tutorialText1 = "To get started, simply add your clothes to your closet by taking pictures and adding a couple of attributes for each of them. \nDon't worry, photo and attributes can be modify once created!"
  let tutorialText2 = "Check the app whenever you need an outfit recommendation. \nFooBar will propose you an outfit based on the current weather, time of the day and much more... If you like the proposition, validate it - if not simply refresh it!"
  
  /*********************************** Mark: - App Life Cycle *****************************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let background = CAGradientLayer().redPinkColor()
    background.frame = self.view.bounds
    self.view.layer.insertSublayer(background, atIndex: 0)
    
    pageTitles = NSArray(objects: "Add your clothes to the app", "Let the app recommend your outfit for the day!")
    pageImages = NSArray(objects: "tutorial1", "tutorial2")
    pageTexts = NSArray(objects: tutorialText1, tutorialText2)
    pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
    pageViewController.dataSource = self
    
    let startVC = viewControllerAtIndex(0) as ContentViewController
    let viewControllers = NSArray(object: startVC)
    pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
    pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 60)
    
    self.addChildViewController(pageViewController)
    self.view.addSubview(pageViewController.view)
    self.pageViewController.didMoveToParentViewController(self)
  }
  
  /*************************************** Mark: - IBAction(s) ****************************************/
  
  @IBAction func skipTutorial(sender: AnyObject) {
    userDefaults.setBool(true, forKey: "hasSkippedTutorial")
    performSegueWithIdentifier("goToHomePage", sender: self)
  }
  
  /********************************** Mark: - Helper method(s) ****************************************/
  
  func viewControllerAtIndex(index: Int) -> ContentViewController {
    if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
      return ContentViewController()
    }
    let vc: ContentViewController = storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
    vc.imageFile = pageImages[index] as! String
    vc.titleText = pageTitles[index] as! String
    vc.tutorialText = pageTexts[index] as! String
    vc.pageIndex = index
    return vc
  }
  
  /****************************** Mark: - PageViewController Datasource *******************************/
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let vc = viewController as! ContentViewController
    var index = vc.pageIndex as Int
    if (index == 0 || index == NSNotFound){
      return nil
    }
    index--
    return viewControllerAtIndex(index)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let vc = viewController as! ContentViewController
    var index = vc.pageIndex as Int
    if (index == NSNotFound){
      return nil
    }
    index++
    if index == self.pageTitles.count {
      return nil
    }
    return viewControllerAtIndex(index)
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pageTitles.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  
}
