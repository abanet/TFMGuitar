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
  var parentScene: SKScene? // escena padre para saber a qué escena volver
  
  // Guitarra, patrón y nivel para jugar
  var guitarra: GuitarraViewController!
  var patron: Patron! //patrón a aprender
  var nivel: Nivel!
  
  // Notas objetivo
  var notasObjetivo: [ShapeNota] = [ShapeNota]()
  var ultimoObjetivoEscogido: String = "" // para evitar q salgan dos intervalos objetivo seguidos
  var posicionInicial: CGPoint! // Posición de notas examen
  
  var radio: CGFloat { // radio de la nota en el corredor
    get {
      //return (Medidas.topSpace) / 3
      return (Medidas.porcentajeTopSpace * size.height) / 5
    }
  }
  
  init(size: CGSize, patron: Patron, nivel: Int = 1) {
    self.patron = patron
    self.nivel = Nivel.getNivel(nivel)
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func didMove(to view: SKView) {
      backgroundColor = Colores.background
      iniciarGuitarra()
      posicionInicial =  CGPoint(x: size.width + Medidas.marginSpace, y: (size.height - Medidas.porcentajeTopSpace * size.height + Medidas.minimumMargin * 2))
      activarSalidaNotas()
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
  
  /**
   Activa la generación de notas de examen.
   Las notas saldrán de forma periodica dependiendo del nivel
  */
  func activarSalidaNotas() {
    let periodo = Double((CGFloat(nivel.tiempoRecorrerPantalla) * (radio * 4)) / size.width)
      run(SKAction.repeatForever(
        SKAction.sequence([SKAction.run() { [weak self] in
          self?.spawnNota()
          }, SKAction.wait(forDuration: periodo)])), withKey: "salidaNotas")
  }
  
  /**
   Crea una nueva nota objetivo y la lanza a la pantalla
  */
  func spawnNota() {
    // Creamos la nota
    let nota = ShapeNota(radio: radio)
    nota.name = "notaObjetivo"
    // Asignamos una interválica al azar
    nota.setTextNota(obtenerObjetivo())
    // Ponemos la nota en movimiento
    nota.position = posicionInicial
    addChild(nota)
    // movimiento constante
    let actionMove = SKAction.moveTo(x: 0, duration: nivel.tiempoRecorrerPantalla)
    nota.run(actionMove)
  }
  
  func obtenerObjetivo() -> String  {
    var intervaloElegido: TipoIntervaloMusical
    repeat { // hasta que encontremos un intervalo diferente del último escogido
      repeat { // hasta encontrar en la interválica un intervalo diferente del unísono/octava
        intervaloElegido = patron.getIntervaloAzar()
      } while intervaloElegido == TipoIntervaloMusical.unisono || intervaloElegido == TipoIntervaloMusical.octavajusta
    } while intervaloElegido.rawValue == ultimoObjetivoEscogido
    ultimoObjetivoEscogido = intervaloElegido.rawValue
    return intervaloElegido.rawValue
  }
  
}
