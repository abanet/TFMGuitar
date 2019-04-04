//
//  Patron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 10/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

enum TipoPatron: String {
    case Escala
    case Arpegio
    case Acorde
}


class Patron {
    
  var nombre: String? // nombre del patrón
  var descripcion: String? // descripción del patrón
  var tipo: TipoPatron?
  
  var trastes: [Traste] = [Traste]()
  
  init(trastes: [Traste]) {
    self.trastes  = trastes
    
  }
  
  func addTraste(_ traste: Traste) {
    trastes.append(traste)
  }
  
  
}
