//
//  Cuerda.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//


import SpriteKit

/**
 La clase StringGuitar representa de forma gráfica una cuerda del mástil de la guitarra
 */
class StringGuitar: SKNode {
    var shape: SKShapeNode
    var numCuerda: Int
    
    
    init(from: CGPoint, to: CGPoint, numCuerda: Int) {
        self.numCuerda = numCuerda
        shape = SKShapeNode.drawLine(from: from, to: to)
        // shape.strokeTexture = SKTexture(imageNamed: "cuerda") // TODO: Hay que buscar texturas más interesantes
        shape.strokeColor = Colores.strings
        shape.lineWidth     = Medidas.widthString
        super.init()
        addChild(shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
