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
  static let PresentAuthenticationViewController = "PresentAuthenticationViewController"
  
  var authenticationViewController: UIViewController?
  var gameCenterEnabled = false
  
  /**
   Función de autenticación en el GameCenter.
   Si el usuario no está autenticado se envía notificación para presentar el viewcontroller de autenticación.
   Si el usuario ya está autenticado se habilita el GameCenter directamente.
  */
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
  
  // Función que informa de la consecución de un logro
  func reportAchievements(achievements: [GKAchievement],
                             errorHandler: ((Error?)->Void)? = nil) {
    guard gameCenterEnabled else { return }
    GKAchievement.report(achievements, withCompletionHandler: errorHandler)
  }
  
  // Mostrar el tablero con los resultados
  func showGKGameCenterViewController(viewController: UIViewController?) {
    guard let viewController = viewController, gameCenterEnabled else {
      return
    }
    let gameCenterViewController = GKGameCenterViewController()
    gameCenterViewController.gameCenterDelegate = self
    viewController.present(gameCenterViewController,
                           animated: true, completion: nil)
  }
  
}

extension GameKitHelper: GKGameCenterControllerDelegate {
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
  
  
}
