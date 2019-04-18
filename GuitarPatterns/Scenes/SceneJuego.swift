//
//  GameScene.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Escena encargada de jugar con un patrón
//  La escena recibirá un patrón como parámetro y un nivel en el que se va a jugar

import SpriteKit

class SceneJuego: SKScene {
  var guitarra: GuitarraViewController!
  var patron: Patron! //patrón a aprender
  var parentScene: SKScene?
  
  init(size: CGSize, patron: Patron) {
    self.patron = patron
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func didMove(to view: SKView) {
      backgroundColor = Colores.background
      iniciarGuitarra()
    }
  
  /**
   Establece una guitarra gráfica con su mástil asociado.
   El mástil se inicializa con el patrón pasado como parámetro
   */
  func iniciarGuitarra() {
    guard let patron = patron else { return }
    
    let sizeGuitar = CGSize(width: size.width, height: size.height * Medidas.porcentajeAltoMastil)
    guitarra = GuitarraViewController(size: sizeGuitar, tipo: .guitarra)
    addChild(guitarra)
    guitarra.dibujarPatron(patron)
  }
  
}
