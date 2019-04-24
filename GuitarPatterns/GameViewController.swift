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
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(showAuthenticationViewController),
        name: NSNotification.Name(GameKitHelper.PresentAuthenticationViewController),
        object: nil)
      GameKitHelper.sharedInstance.authenticateLocalPlayer()
      
        super.viewDidLoad()
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
