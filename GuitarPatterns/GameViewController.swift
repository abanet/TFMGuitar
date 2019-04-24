//
//  GameViewController.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
      // Autenticamos al usuario en el GameCenter nada más comenzar el juego
      // La configuración del apodo del usuario se realiza desde la configuración de GameCenter en los ajustes del dispositivo móvil.
      
      // Notificación pendiente de las notificación de GameKit
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(showAuthenticationViewController),
        name: NSNotification.Name(GameKitHelper.PresentAuthenticationViewController),
        object: nil)
      // Lanzamos autenticación del usuario
      GameKitHelper.sharedInstance.authenticateLocalPlayer()
      
        super.viewDidLoad()
      
      // Lanzamos la escena principal
        let dimensionesDispositivo = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let scene = SceneMenuPrincipal(size: dimensionesDispositivo)
        //SceneMenu(size:CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        //SceneEditor(size:CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
  
  @objc func showAuthenticationViewController() {
    let gameKitHelper = GameKitHelper.sharedInstance
    if let authenticationViewController =
      gameKitHelper.authenticationViewController {
      self.present(
        authenticationViewController,
        animated: true, completion: nil)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}
