//
//  GameKitHelper.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 24/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Funciones para la validación del usuario en el GameCenter de Apple.

import Foundation
import UIKit
import GameKit




class GameKitHelper: NSObject {
  
  static let sharedInstance = GameKitHelper()
  static let PresentAuthenticationViewController =
  "PresentAuthenticationViewController"
  
  var authenticationViewController: UIViewController?
  var gameCenterEnabled = false
  
  
  func authenticateLocalPlayer() {
    GKLocalPlayer.local.authenticateHandler =
      { (viewController, error) in
        self.gameCenterEnabled = false
        if viewController != nil {
          self.authenticationViewController = viewController
          NotificationCenter.default.post(name: NSNotification.Name(
            GameKitHelper.PresentAuthenticationViewController),
                                          object: self)
        } else if GKLocalPlayer.local.isAuthenticated {
          self.gameCenterEnabled = true
        }
    }
  }
  
  
}
