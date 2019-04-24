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
    static let botones = UIColor.orange
    static let botonPrincipalOff = UIColor.lightGray.withAlphaComponent(0.35)
    static let botonPrincipalOn = UIColor.orange.withAlphaComponent(0.35)
    static let fallo = SKColor.darkGray
    static let acierto = SKColor.green
    static let indicaciones = SKColor.white
}

/// Contiene las medidas generales de la aplicación
struct Medidas {
    
    // Márgenes de la app teniendo en cuenta el tipo de dispositivo
    static let minimumMargin: CGFloat = 8.0
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
    static let widthString: CGFloat = 3.0 // 5.0
    /// número de trastes a mostrar en el mástil
    static let numTrastes = 7
    /// ratio entre espacio entre cuerdas y el tamaño de la nota
    static let ratioCuerdasNota: CGFloat = 2.4

    // Patrones en menu
  static let numeroPatronesEnPantalla: CGFloat = 2.0

    // Juego
    static let trasteRuedaDentada: Int = 1
}

struct Notas {
    static let font = "AvenirNext-Regular"
}

struct Letras {
    static let normal = "Nexa-Book"
    static let negrita = "Nexa-Bold"
    static let contador = "Menlo"
    static let puntosNota = "GillSans-BoldItalic"
    static let pizarra = "Chalkduster"
}
struct zPositionNodes {
    static let background: CGFloat = -3.0
    static let trastes: CGFloat    = -2.0
    static let cuerdas: CGFloat    = -1.0
    static let foreground: CGFloat = 10
    static let panel: CGFloat = 100
}

struct Mensajes {
  static let partidaperdida = [
    "¿Te llaman mano lenta? 🤣",
    "¡Los he visto más rápidos! 😂",
    "¡Practica hasta que te duela la cabeza!",
    "No doy crédito... 😱",
    "😳 me has dejado sin palabras...",
    "Venga Jimmy Hendrix, ¡un poco más de esfuerzo!",
    "¡Puedes hacerlo mejor!"
  ]
}
