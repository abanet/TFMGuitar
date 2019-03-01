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
    
    // Strings
    /// ancho de la cuerda
    static let widthString: CGFloat = 3.0
    
  
}
