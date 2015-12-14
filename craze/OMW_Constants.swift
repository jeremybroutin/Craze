//
//  OMW_Constants.swift
//  foobar
//
//  Created by Jeremy Broutin on 10/21/15.
//  Copyright (c) 2015 Jeremy Broutin. All rights reserved.
//

import Foundation

extension OWM_Client {
  
  struct Constants {
    static let baseSecureURLString = "http://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "3298810d9dc05333b550e0dd72f2ca60"
  }
  
  struct JSONResponseKeys {
    static let Coordinates = "coord"
    static let System = "sys"
    static let Weather = "weather"
    static let Main = "main"
    static let Temperature = ""
    static let Wind = "wind"
    static let Rain = "rain"
    static let City = "name"
    static let ResponseCode = "cod"
    static let ResponseMessage = "message"
  }
  
  struct JSONResponseValues {
    static let SuccessCode: Int = 200
  }
  
}