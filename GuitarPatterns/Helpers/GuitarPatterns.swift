//
//  Entorno.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Declaración de todos los parámetros constantes de la app
//  Colores, márgenes, ...

import SpriteKit

/// Constantes de los colores de la aplicación
struct Colores {
    static let background   = SKColor.lightGray
    static let strings      = SKColor.black
    static let noteStroke   = SKColor.black
    static let noteFill     = SKColor.lightGray //SKColor.clear
    static let noteFillResaltada = SKColor.orange
    static let tonica = SKColor.red
}

/// Contiene las medidas generales de la aplicación
struct Medidas {
    
    // Márgenes de la app teniendo en cuenta el tipo de dispositivo
    static let topSpace: CGFloat = 50.0 // espacio reservado para la comunicación
    static let bottomSpace: CGFloat = 50.0 // aire en la parte inferior
    static let marginSpace: CGFloat = 50.0 // aire a los lados
    static let porcentajeTopSpace: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 0.20
        case .pad:
            return 0.30
        default:
            return 0.25
        }
    }()
    static let porcentajeAltoMastil: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 0.65
        case .pad:
            return 0.30
        default:
            return 0.25
        }
    }()
    
    // Strings
    /// ancho de la cuerda
    static let widthString: CGFloat = 5.0
    /// número de trastes a mostrar en el mástil
    static let numTrastes = 7
    /// ratio entre espacio entre cuerdas y el tamaño de la nota
    static let ratioCuerdasNota: CGFloat = 2.4

}

struct Notas {
    static let font = "AvenirNext-Regular"
}

struct zPositionNodes {
    static let background: CGFloat = -3.0
    static let trastes: CGFloat    = -2.0
    static let cuerdas: CGFloat    = -1.0
}
