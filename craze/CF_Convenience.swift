//
//  CF_Convenience.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/10/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import UIKit

extension CF_Client {
  
  func postImageToCamFind(image: UIImage, completionHandler: (token: String?, error: NSError?) -> Void) {
    
    // 1- Convert image to binary data and then base64string
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
    
    // 2- Set JSON Body accordingly
    let jsonBody: [String: AnyObject] = [
      JSONBodyKeys.FocusX: JSONBodyDefaultValues.FocusX,
      JSONBodyKeys.FocusY: JSONBodyDefaultValues.FocusY,
      JSONBodyKeys.ImageRequestAltitude: JSONBodyDefaultValues.ImageRequestAltitude,
      JSONBodyKeys.ImageRequestImage: base64String,
      JSONBodyKeys.ImageRequestLanguage: JSONBodyDefaultValues.ImageRequestLanguage,
      JSONBodyKeys.ImageRequestLatitude: JSONBodyDefaultValues.ImageRequestLatitude,
      JSONBodyKeys.ImageRequestLongitude: JSONBodyDefaultValues.ImageRequestLongitude,
      JSONBodyKeys.ImageRequestLocale: JSONBodyDefaultValues.ImageRequestLocale,
      JSONBodyKeys.ImageRequestRemoteURLImage: JSONBodyDefaultValues.ImageRequestRemoteURLImage
    ]
    
    // 3- Make the request
    taskForPOSTMethod(jsonBody) { JSONResult, error in
      print("taskForPOSTMethod is called")
      if let error = error {
        completionHandler(token: nil, error: error)
      } else if let errorResponse = JSONResult[JSONResponseKeys.Error] as? String {
        print("postImagetoCamFind error is: \(errorResponse)")
      } else {
        if let token = JSONResult[JSONResponseKeys.Token] as? String {
            completionHandler(token: token, error: nil)
        } else {
          completionHandler(token: nil, error: NSError(domain: "postImageToCamFind", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find 'token' in postImageToCamFind JSONResult"]))
        }
        }
      }
  }
  
}