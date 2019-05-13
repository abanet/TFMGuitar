//
//  Nota.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

/**
 Nombre de la nota en notación anglosajona.
 */
enum NombreNota: String {
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case A = "A"
    case B = "B"
}

/**
 La representación de una nota musical es un texto con un nombre de nota asignato
 */
struct Nota {
    private var nombre: NombreNota
    
    init(nombre: NombreNota) {
        self.nombre = nombre
    }
    
    func getNombreAsText() -> String {
        return self.nombre.rawValue
    }
    
    mutating func setNombre(_ nombre: NombreNota) {
        self.nombre = nombre
    }
    
    
}
