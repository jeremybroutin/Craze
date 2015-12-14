//
//  OWM_Convenience.swift
//  foobar
//
//  Created by Jeremy Broutin on 10/21/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation

extension OWM_Client {
  
  func getWeatherInfo(lat: Double, lon: Double, completionHandler: (success: Bool, weather: WeatherInfo, error: NSError?)-> Void){
    let methodParameters = [
      "lat": lat,
      "lon": lon,
      "appid": Constants.apiKey
    ]
    taskForGETMethod(methodParameters as! [String : AnyObject]){ JSONResult, error in
      if let _ = error {
        print("error in taskForGETMethod")
        //completionHandler(success: false, weather: nil, error: error)
      }
      else {
        var result: WeatherInfo?
        if let weatherData = JSONResult as? NSDictionary {
          result = WeatherInfo(data: weatherData)
        }
        completionHandler(success: true, weather: result!, error: nil)
      }
    }
  }
  
}
