//
//  ContentViewController.swift
//  foobar
//
//  Created by Jeremy Broutin on 12/13/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var tutorialLabel: UILabel!

  
  var pageIndex: Int!
  var titleText: String!
  var imageFile: String!
  var tutorialText: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = UIImage(named: imageFile)
    titleLabel.text = titleText
    view.backgroundColor = UIColor.clearColor()
    
    tutorialLabel.text = tutorialText
  }
  
}
