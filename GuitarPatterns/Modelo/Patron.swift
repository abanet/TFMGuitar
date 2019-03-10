//
//  Patron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 10/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class Patron {
  
  var trastes: [Traste] = [Traste]()
  
  init(trastes: [Traste]) {
    self.trastes  = trastes
  }
  
  func addTraste(_ traste: Traste) {
    trastes.append(traste)
  }
  
  
}
