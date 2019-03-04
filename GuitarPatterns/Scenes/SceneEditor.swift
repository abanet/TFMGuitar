//
//  SceneEditor.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 01/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Scene que permite creación / edición de un patrón
 */

class SceneEditor: SKScene {
    var guitarra: GuitarraViewController!
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
    }
    
    
    func iniciarGuitarra() {
        guitarra = GuitarraViewController(size: size, tipo: .guitarra)
        addChild(guitarra)
    }
}
