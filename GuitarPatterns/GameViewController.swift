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
        super.viewDidLoad()
        
        let scene = //SceneMenu(size:CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            SceneEditor(size:CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
