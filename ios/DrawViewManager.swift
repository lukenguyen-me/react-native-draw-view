//
//  DrawViewManager.swift
//  DrawView
//
//  Created by Loc Nguyen on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc (DrawViewManager)
class DrawViewManager: RCTViewManager {
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func view() -> UIView! {
    return DrawView()
  }
  
  @objc func reset(_ node: NSNumber) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(forReactTag: node) as! DrawView
      component.reset()
    }
  }
  
  @objc func save(_ node: NSNumber) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(forReactTag: node) as! DrawView
      component.save()
    }
  }
}
