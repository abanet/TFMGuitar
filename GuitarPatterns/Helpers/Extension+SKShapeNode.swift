//
//  Extension+SKShapeNode.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Extensión de la clase SKShapeNode
//  Implementa las funciones gráficas básicas
import SpriteKit

extension SKShapeNode {
    /**
     
     Crea y devuelve un SKShapeNode con una línea que va entre los puntos pasados como parámetros
     
     - Parameter from: punto origen
     - Parameter to: punto final
     
     */
    class func drawLine(from: CGPoint, to: CGPoint) -> SKShapeNode {
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.addLines(between: [from, to])
        line.path = path
        return line
    }
    
    /**
     
     Devuelve un SKShapeNode en forma de círculo
     
     - Parameter center: centro del círculo
     - Parameter radius: radio del círculo
     
     */
    class func drawCircleAt(_ center: CGPoint, withRadius radius: CGFloat) -> SKShapeNode {
        let circle = SKShapeNode()
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        return circle
    }
}
