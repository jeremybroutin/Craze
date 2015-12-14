//
//  OWM_Client.swift
//  craze
//
//  Created by Jeremy Broutin on 10/21/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation

class OWM_Client: NSObject {
  
  // Shared session
  var session: NSURLSession
  
  override init() {
    session = NSURLSession.sharedSession()
    super.init()
  }
  
  // Task for GET method
  func taskForGETMethod(parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
    let urlString = Constants.baseSecureURLString + OWM_Client.escapedParameters(parameters)
    let url = NSURL(string: urlString)!
    let request = NSMutableURLRequest(URL: url)
    
    let task = session.dataTaskWithRequest(request){ data, response, downloadError in
      if let error = downloadError {
        // let newError = OWM_Client.errorForData(data, response: response, error: error)
        completionHandler(result: nil, error: error)
      }
      else {
        OWM_Client.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
      }
    }
    task.resume()
    return task
  }
  
  
  /* MARK: - Helper functions */
  
  // Helper: Given a response with error, see if a message is returned, otherwise return the previous error
  class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
    
    if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {
      
      if let errorMessage = parsedResult[OWM_Client.JSONResponseKeys.ResponseMessage] as? String {
        let userInfo = [NSLocalizedDescriptionKey : errorMessage]
        return NSError(domain: "Parse Error", code: 0, userInfo: userInfo)
      }
    }
    return error
  }
  
  // Helper: Given raw JSON, return a usable Foundation object
  class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
    
    var parsingError: NSError? = nil
    let parsedResult: AnyObject?
    do {
      parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
    } catch let error as NSError {
      parsingError = error
      parsedResult = nil
    }
    
    if let error = parsingError {
      completionHandler(result: nil, error: error)
    } else {
      completionHandler(result: parsedResult, error: nil)
    }
  }
  
  // Helper function: Given a dictionary of parameters, convert to a string for a url
  class func escapedParameters(parameters: [String : AnyObject]) -> String {
    var urlVars = [String]()
    for (key, value) in parameters {
      
      // Make sure that it is a string value
      let stringValue = "\(value)"
      // Escape it
      let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
      // Append it
      urlVars += [key + "=" + "\(escapedValue!)"]
    }
    return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
  }
  
  /* MARK: - Shared Instance */
  
  class func sharedInstance() -> OWM_Client {
    struct Singleton {
      static var sharedInstance = OWM_Client()
    }
    return Singleton.sharedInstance
  }
  
}
