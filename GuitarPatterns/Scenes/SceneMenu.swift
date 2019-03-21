//
//  SceneMenu.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class SceneMenu: SKScene {
    
    let menu = SKNode()
    var startLocationX: CGFloat = 0.0
    var moviendo: Bool = false
    
    let viewGuitarra = GuitarraView(size: CGSize(width: 250, height: 150))
    
    override func didMove(to view: SKView) {
        backgroundColor = .brown
        var x: CGFloat = 0.0
        
        for n in 1...5 {
            let nuevoMastil = GuitarraView(size: CGSize(width: 250, height: 150))
            nuevoMastil.position = CGPoint(x: x, y: 50)
            x += 300
            menu.addChild(nuevoMastil)
            
        }
        addChild(menu)
        menu.name = "menu"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if menu.contains(location) {
                moviendo = true
                startLocationX = menu.position.x - location.x
            }
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moviendo {
          let location = touch.location(in: self)
          menu.position.x = location.x + startLocationX
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moviendo = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moviendo = false
    }
    
}
