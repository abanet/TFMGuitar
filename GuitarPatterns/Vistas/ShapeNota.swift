//
//  ShapeNota.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 01/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Estados en los que se puede encontrar una nota
 */
enum TipoShapeNota {
    case unselected
    case selected
    case tonica
}

/**
 Representación gráfica de una nota en el mástil
 */
class ShapeNota: SKNode {
    var radio: CGFloat
    var shape: SKShapeNode
    var literal: SKLabelNode
    var text: String?
    var tag: String?
    
    
    init(radio: CGFloat){
        shape   = SKShapeNode.drawCircleAt(.zero, withRadius: radio)
        literal = SKLabelNode(fontNamed: Notas.font)
        self.radio = radio
        super.init()
        decorarNota()
        shape.addChild(literal)
        addChild(shape)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextNota(_ text: String) {
        literal.text = text
    }
    
    func getTextNota() -> String? {
        return literal.text
    }
    
    func setTagNota(_ tag: String) {
        self.tag = tag
    }
    
    func getTagNota()  -> String? {
        return tag
    }
    
    /**
     Configura el aspecto inicial de la nota
    */
    func decorarNota() {
        shape.fillColor     = Colores.noteFill
        shape.strokeColor   = Colores.noteStroke
        shape.lineWidth     = 1.0 // siempre
        shape.glowWidth     = 0.5 // always
        literal.fontSize = radio * 1.2
        literal.verticalAlignmentMode = .center
        literal.horizontalAlignmentMode = .center
        literal.alpha = 1.0
        
    }
}

