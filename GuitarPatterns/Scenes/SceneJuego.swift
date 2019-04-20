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
  var efectos: EfectosEspeciales = EfectosEspeciales()
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
  
  // Actualización de la escena
  override func update(_ currentTime: TimeInterval) {
    comprobarDestruccionNotas()
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchPosition = touch.location(in: self)
    let touchedNodes = nodes(at: touchPosition)
    for node in touchedNodes {
      if let mynode = node as? ShapeNota, node.name == "nota", mynode.getTagNota() != "T" {
        // si hemos acertado sumar un punto y eliminar la primera nota
        if let textoEnNota = mynode.getTagNota(), textoEnNota == notasObjetivo[0].getTextNota() {
          // Marcar en verde como que está acertada pero hay q comprobar que no queden más
          mynode.coloreaCon(UIColor.green)
          mynode.name = "notaAcertada"
          efectos.hacerSonarNotaConTonica(mynode)
          if !quedanNotas(withText: textoEnNota) {
            // se acertaron todas, eliminar notaObjetivo y restaurar mástil para que todas las notas sean "nota"
            
            if let nota = notasObjetivo.first {
              nota.coloreaCon(Colores.acierto)
              self.notasObjetivo.remove(at: 0)
              nota.run(SKAction.afterDelay(0.5) {
                nota.removeFromParent()
              })
              
//              acierto()
            }
            let espera = SKAction.wait(forDuration: 0.5)
            self.isUserInteractionEnabled = false
            run(espera) {
              self.restaurarNombresNotasEnMastil()
              self.isUserInteractionEnabled = true
            }
          } else {
            // aún quedan notas por acertar
          }
          
        } else {
          // colorear en gris para que se vea que se ha utilizado (modo ayuda on)
          mynode.coloreaCon(Colores.fallo)
          mynode.name = "notaFallada"
          //fallo()
        }
        
      }
    }
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
    self.ajustarMastilNivel()
  }
  
  func ajustarMastilNivel() {
    guitarra.viewGuitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
      if let shapeNota = nodoNota as? ShapeNota,
         let tagNota = shapeNota.getTagNota(),
         tagNota != TipoIntervaloMusical.tonica().rawValue {
            if !self.nivel.marcarNotas {
              shapeNota.coloreaCon(Colores.noteFill)
            }
            if !self.nivel.mostrarNotas {
              shapeNota.setTextNota("")
            }
          }
        }
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
    let textNota = obtenerObjetivo()
    nota.setTextNota(textNota)
    nota.setTagNota(textNota)
    // Ponemos la nota en movimiento
    nota.position = posicionInicial
    addChild(nota)
    notasObjetivo.append(nota)
    // movimiento constante
    let actionMove = SKAction.moveTo(x: 0, duration: nivel.tiempoRecorrerPantalla)
    nota.run(actionMove)
  }
  
  /**
   Obtiene el nombre de una nota objetivo.
   Tiene que pertenecer a la interválica del patrón y ser diferente del último objetivo.
   */
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
  
  /**
    Comprueba si hay que destruir algún nodo objetivo
  */
  func comprobarDestruccionNotas() {
    let posFinNotaX = guitarra.viewGuitarra.posicionXTraste(num: 2)
    enumerateChildNodes(withName: "notaObjetivo") {[unowned self] (node, _) in
      if node.position.x <= posFinNotaX { // Punto x tope para las bolas
        let down = SKAction.moveTo(y: 0, duration: 1.0)
        let alpha = SKAction.fadeAlpha(to: 0, duration: 1.0)
        let downalpha = SKAction.group([down,alpha])
        
        node.run(downalpha) {
          let explosion = EfectosEspeciales.explosion(intensity: 2.0)
          self.addChild(explosion)
          explosion.position = node.position
          node.removeFromParent()
          self.notasObjetivo.remove(at: 0)
        }
      }
    }
  }
  
  /**
   Devuelve true si quedan notas marcadas como "nota" con el tag pasado como parámetro
  */
  func quedanNotas(withText text: String) -> Bool {
    for child in guitarra.viewGuitarra.children {
      if let nodo = child as? ShapeNota, nodo.name == "nota" {
        if nodo.getTagNota() == text {
          return true
        }
      }
    }
    return false
  }
  
  /**
   Repasa las notas del juego y las nombra como notas normales, reseteando los estados de fallo o acierto que se hayan producido durante el juego.
  */
  func restaurarNombresNotasEnMastil() {
    for child in guitarra.viewGuitarra.children {
      if let shapeNota = child as? ShapeNota, shapeNota.name == "notaFallada" || shapeNota.name == "notaAcertada" {
        shapeNota.name = "nota"
        if shapeNota.getTagNota() != nil && nivel.marcarNotas { // contiene información de nota
          shapeNota.coloreaCon(Colores.noteFillResaltada)
        } else {
          shapeNota.coloreaCon(Colores.noteFill)
        }
      }
    }
  }
}
