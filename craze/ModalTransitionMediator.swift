//
//  ModalTransitionMediator.swift
//  craze
//
//  Created by Jeremy Broutin on 12/8/15.
//  Copyright © 2015 Jeremy Broutin. All rights reserved.
//

import Foundation

protocol ModalTransitionListener {
  func popoverDismissed()
}

class ModalTransitionMediator {
  
  /* Singleton */
  class func sharedInstance() -> ModalTransitionMediator {
    struct Singleton {
      static var sharedInstance = ModalTransitionMediator()
    }
    return Singleton.sharedInstance
  }
  /*class var instance: ModalTransitionMediator {
    struct Static {
      static let instance: ModalTransitionMediator = ModalTransitionMediator()
    }
    return Static.instance
  }*/
  
  private var listener: ModalTransitionListener?
  
  private init() { 
  }
  
  func setListener(listener: ModalTransitionListener) {
    self.listener = listener
  }
  
  func sendPopoverDismissed(modelChanged: Bool) {
    listener?.popoverDismissed()
  }
}

