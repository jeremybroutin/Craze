//
//  ClotheCell.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/2/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

class ClotheCell : UICollectionViewCell {
  
  // The property uses a property observer. Any time its
  // value is set it canceles the previous NSURLSessionTask
  
  @IBOutlet weak var clotheImageView: UIImageView!
  @IBOutlet weak var colorLine: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var selectedIcon: UIImageView!
  
  var taskToCancelifCellIsReused: NSURLSessionTask? {
    
    didSet {
      if let taskToCancel = oldValue {
        taskToCancel.cancel()
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //self.clotheImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //self.clotheImageView.autoresizingMask = .None
    //self.clotheImageView.translatesAutoresizingMaskIntoConstraints = true;
  }
  
  var image: UIImage?{
    set{
      self.clotheImageView.image = newValue
    }
    get{
      return self.clotheImageView.image ?? nil
    }
  }
}
