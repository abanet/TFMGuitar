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
        guitarra.poblarMastil()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchPosition = touch.location(in: self)
        let touchedNodes  = nodes(at:touchPosition)
        for node in touchedNodes {
            if let miNodo = node as? ShapeNota, node.name == "nota" {
                // Se ha tocado un traste con una nota
                switch miNodo.tipoShapeNota {
                case .unselected:
                    miNodo.setTipoShapeNote(.selected)
                case .selected:
                    miNodo.setTipoShapeNote(.tonica)
                case .tonica:
                    miNodo.setTipoShapeNote(.unselected)
                    
                }
                
            }
        }
    }
}
