//
//  CAGradientLayerExtensions.swift
//  craze
//
//  Created by Jeremy Broutin on 12/12/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
  
  func redPinkColor() -> CAGradientLayer {
    
    let topColor = UIColor(red:0.98, green:0.37, blue:0.29, alpha:1.0)
    let bottomColor = UIColor(red:0.98, green:0.33, blue:0.48, alpha:1.0)
    
    let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
    let gradientLocalization: [Float] = [0.0, 1.0]
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors
    gradientLayer.locations = gradientLocalization
    
    return gradientLayer
    
  }
}
