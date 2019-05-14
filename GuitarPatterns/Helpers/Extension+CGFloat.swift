//
//  Extension+CGFloat.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import CoreGraphics

let π = CGFloat(Double.pi)

public extension CGFloat {
    
    /**
     Genera un número aleatorio
     */
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    /**
     Genera un número aleatorio entre un mínimo y un máximo dados.
     */
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
    
    /**
     * Convertir de grados a radianes
     */
    func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
    
    /**
     * Convertir de radianes a grados
     */
    func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }
    
}
