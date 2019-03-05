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


struct Nota {
    var nombre: NombreNota
    var intervalo: TipoIntervaloMusical? // intervalo que juega esa nota
}
