//
//  CF_Client.swift
//  foobar
//
//  Created by Jeremy Broutin on 11/10/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import CoreData

class CF_Client: NSObject {
  
  
  // Shared session
  var session: NSURLSession
  
  override init() {
    session = NSURLSession.sharedSession()
    super.init()
  }

  
  func taskForPOSTMethod(jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
    
    // 1- set the parameter (here only API key is needed)
    //var mutableParameters = [String:AnyObject]()
    //mutableParameters[ParametersKey.APIKey] = Constants.APIKey
    
    // 2- build the url and configure the request
    //let urlString = Constants.BaseURLSecure + CF_Client.escapedParameters(mutableParameters)
    let urlString = Constants.BaseURLSecure
    let url = NSURL(string: urlString)!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("X-Mashape-Key", forHTTPHeaderField: "Nmz7Cq70XxmshkFNbnVKCswiOvGWp1Vu67kjsnpxp3eJgnm4YT")
    do {
      request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
    }
    
    // 3- Make the request
    let task = session.dataTaskWithRequest(request) { data, response, error in
      // GUARD: Was there an error?
      guard(error == nil) else {
        print("There was an error with the request: \(error)")
        return
      }
      // GUARD: Did we get a successful 200 response?
      guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
        if let response = response as? NSHTTPURLResponse {
          print("The request returned an invalid response! Status code: \(response.statusCode)!")
        } else if let response = response {
          print("The request returned an invalid response! Response: \(response)!")
        } else {
          print("Your request returned an invalid response!")
        }
        return
      }
      // GUARD: WAS tthere any data returned?
      guard let data = data else {
        print("No data was returned by the request!")
        return
      }
      
      // 4- Parse the data and use it
      CF_Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
    }
    task.resume()
    return task
  }

  
  
  /* Helper function: Given a dictionary of parameters, convert to a string for a url */
  class func escapedParameters(parameters: [String : AnyObject]) -> String {
    
    var urlVars = [String]()
    for (key, value) in parameters {
      /* Make sure that it is a string value */
      let stringValue = "\(value)"
      /* Escape it */
      let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
      /* Append it */
      urlVars += [key + "=" + "\(escapedValue!)"]
    }
    return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
  }

  /* Helper: Given raw JSON, return a usable Foundation object */
  class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
    
    var parsedResult: AnyObject!
    do {
      parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
    } catch {
      let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
      completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandler(result: parsedResult, error: nil)
  }
  
  /* MARK: Shared Instance */
  class func sharedInstance() -> CF_Client {
    struct Singleton {
      static var sharedInstance = CF_Client()
    }
    return Singleton.sharedInstance
  }

}
