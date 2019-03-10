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
   private var radio: CGFloat      // radio de la nota
   private var shape: SKShapeNode  // forma de la nota
   private var literal: SKLabelNode    // nodo para el contenido textual descriptivo de la nota/intervalo
   private var text: String?       // contenido textual descriptivo
   private var tag: String?
   private var traste: Traste? {// traste asociado a la nota dibujada
        didSet {
            if let traste = traste {
                switch traste.getEstado() {
                case let .nota(nota):
                    self.setTextNota(nota.getNombreAsText())
                case let .intervalo(intervalo):
                  if intervalo.esTonica() { // Las octavas se muestran siempre como tónicas.
                    self.setTextNota(TipoIntervaloMusical.unisono.rawValue)
                    tipoShapeNota = .tonica
                  } else {
                    self.setTextNota(intervalo.rawValue)
                  }
                default:
                    break
                }
            }
        }}
    
    private var tipoShapeNota: TipoShapeNota = .unselected {
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
        //self.posicion = posicion
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: getters y setters
    func setTipoShapeNote(_ valor: TipoShapeNota) {
        tipoShapeNota = valor
    }
    
    func getTipo() -> TipoShapeNota {
        return tipoShapeNota
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
    
    func getShape() -> SKShapeNode {
        return self.shape
    }
    
    func setTraste(_ traste: Traste) {
        self.traste = traste
    }
    
    func getTraste() -> Traste? {
        return self.traste
    }
    
    func isInPosition(posX: CGFloat, posY: CGFloat) -> Bool {
        return shape.position.x == posX && shape.position.y == posY
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

