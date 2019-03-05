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
    var radio: CGFloat      // radio de la nota
    var shape: SKShapeNode  // forma de la nota
    var literal: SKLabelNode    // nodo para el contenido textual descriptivo de la nota/intervalo
    var text: String?       // contenido textual descriptivo
    var tag: String?
    var posicion: PosicionTraste?
   
    private(set) var tipoShapeNota: TipoShapeNota = .unselected {
        didSet {
            switch tipoShapeNota {
            case .unselected:
                shape.fillColor = Colores.noteFill
                setTextNota("")
            case .selected:
                shape.fillColor = Colores.noteFillResaltada
                setTextNota("")
            case .tonica:
                shape.fillColor = Colores.tonica
                setTextNota("T")
            
            }
        }
    }
    
    init(radio: CGFloat){
        shape   = SKShapeNode.drawCircleAt(.zero, withRadius: radio)
        literal = SKLabelNode(fontNamed: Notas.font)
        self.radio = radio
        super.init()
        configurarNota()
        shape.addChild(literal)
        addChild(shape)
        self.name = "nota"
    }
    
    
    convenience init(posicion: PosicionTraste, radio: CGFloat) {
        self.init(radio: radio)
        self.posicion = posicion
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTipoShapeNote(_ valor: TipoShapeNota) {
        tipoShapeNota = valor
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
    func configurarNota() {
        shape.fillColor     = Colores.noteFill
        shape.strokeColor   = Colores.noteStroke
        shape.lineWidth     = 1.0 // siempre
        shape.glowWidth     = 0.5 // always
        shape.alpha         = 1.0
        literal.fontSize = radio * 1.2
        literal.verticalAlignmentMode = .center
        literal.horizontalAlignmentMode = .center
        literal.alpha = 1.0
        
    }
}

