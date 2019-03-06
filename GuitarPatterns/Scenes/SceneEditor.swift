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
        let nota = Nota(nombre: NombreNota(rawValue: "G")!)
       // let traste = Traste(cuerda: 3, traste: 3, estado: .nota(nota))
        guitarra.marcarNotaTocada(touches, conNota: nota)
    }
}
