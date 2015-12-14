//
//  WeatherInfo.swift
//  craze
//
//  Created by Jeremy Broutin on 10/22/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherInfo {
  var cityName: String
  var cityCoord: CLLocationCoordinate2D
  var temperature: Float
  var weatherMain: String
  
  init(data: NSDictionary){
    cityName = data["name"] as! String
    // access the coord dictionary that contains the coordinates
    let coord: NSDictionary = data["coord"] as! NSDictionary
    cityCoord = CLLocationCoordinate2D(latitude: coord["lat"]!.doubleValue, longitude: coord["lon"]!.doubleValue)
    // access the main dictionary that contains the temperature info
    let main: NSDictionary = data["main"] as! NSDictionary
    temperature = main["temp"]!.floatValue - 273.15 // to convert from Kelvin to Celsius
    // access the weather array of dictionaries that contains the main weather info
    let weather: [NSDictionary] = data["weather"] as! [NSDictionary]
    weatherMain = weather[0].valueForKey("main")! as! String
  }
}
