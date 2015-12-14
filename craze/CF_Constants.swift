//
//  CF_Constants.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/10/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

extension CF_Client {
  
  
  struct Constants {
    static let APIKey:String = "Nmz7Cq70XxmshkFNbnVKCswiOvGWp1Vu67kjsnpxp3eJgnm4YT"
    static let BaseURLSecure:String = "https://camfind.p.mashape.com/image_requests"
  }
  
  struct ParametersKey {
    static let APIKey:String = "X-Mashape-Key"
  }
  
  struct JSONBodyKeys {
    static let FocusX = "focus[x]"
    static let FocusY = "focus[y]"
    static let ImageRequestAltitude = "image_request[altitude]"
    static let ImageRequestImage = "image_request[image]"
    static let ImageRequestLanguage = "image_request[language]"
    static let ImageRequestLatitude = "image_request[latitude]"
    static let ImageRequestLongitude = "image_request[longitude]"
    static let ImageRequestLocale = "image_request[locale]"
    static let ImageRequestRemoteURLImage = "image_request[remote_image_url]"
  }
  
  struct JSONBodyDefaultValues {
    static let FocusX = "480"
    static let FocusY = "640"
    static let ImageRequestAltitude = ""
    //static let ImageRequestImage: UIImage
    static let ImageRequestLanguage = "en"
    static let ImageRequestLatitude = ""
    static let ImageRequestLongitude = ""
    static let ImageRequestLocale = "en_US"
    static let ImageRequestRemoteURLImage = ""
  }
  
  struct JSONResponseKeys {
    static let Token = "token"
    static let Status = "status"
    static let Name = "name"
    static let Error = "error"
  }
  
  // All the below should go in the jsonBody
  /*
  NSDictionary *parameters = @{@"focus[x]": @"480", @"focus[y]": @"640", @"image_request[altitude]": @"27.912109375", @"image_request[image]": urlimage_request[image], @"image_request[language]": @"en", @"image_request[latitude]": @"35.8714220766008", @"image_request[locale]": @"en_US", @"image_request[longitude]": @"14.3583203002251", @"image_request[remote_image_url]": @"http://upload.wikimedia.org/wikipedia/en/2/2d/Mashape_logo.png"};
  */
  
}