//
//  EfectosEspaciales.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class EfectosEspeciales {
  // Sonidos
  let collectcoin = SKAction.playSoundFileNamed("collectcoin.wav", waitForCompletion: true)
  let dropBomb = SKAction.playSoundFileNamed("bombDrop.wav", waitForCompletion: true)
  let sonidoC0 = SKAction.playSoundFileNamed("C0.wav", waitForCompletion: false)
  let sonidoC0s = SKAction.playSoundFileNamed("C0#.wav", waitForCompletion: false)
  let sonidoD0 = SKAction.playSoundFileNamed("D0.wav", waitForCompletion: false)
  let sonidoD0s = SKAction.playSoundFileNamed("D0#.wav", waitForCompletion: false)
  let sonidoE0 = SKAction.playSoundFileNamed("E0.wav", waitForCompletion: false)
  let sonidoF0 = SKAction.playSoundFileNamed("F0.wav", waitForCompletion: false)
  let sonidoF0s = SKAction.playSoundFileNamed("F0#.wav", waitForCompletion: false)
  let sonidoG0 = SKAction.playSoundFileNamed("G0.wav", waitForCompletion: false)
  let sonidoG0s = SKAction.playSoundFileNamed("G0#.wav", waitForCompletion: false)
  let sonidoA0 = SKAction.playSoundFileNamed("A0.wav", waitForCompletion: false)
  let sonidoA0s = SKAction.playSoundFileNamed("A0#.wav", waitForCompletion: false)
  let sonidoB0 = SKAction.playSoundFileNamed("B0.wav", waitForCompletion: false)
  var sonidos = [SKAction]()
  
  init() {
    // cargamos los sonidos
    sonidos = [sonidoC0, sonidoC0s, sonidoD0, sonidoD0s, sonidoE0, sonidoF0, sonidoF0s, sonidoG0, sonidoG0s, sonidoA0, sonidoA0s, sonidoB0]
  }
  
  /**
   Hace sonar la nota representada por el nodo pasado como parámetro
  */
  func hacerSonarNota(_ nodoNota: ShapeNota) {
    if let distanciaTonica = nodoNota.getTraste()?.getIntervalo()?.distancia() {
      let distancia = distanciaTonica % 12
      nodoNota.run(sonidos[distancia])
    }
  }
  
  func hacerSonarNotaConTonica(_ nodoNota: ShapeNota) {
    if let distanciaTonica = nodoNota.getTraste()?.getIntervalo()?.distancia()  {
      let distancia = distanciaTonica % 12
      let secuenciaSonidos = SKAction.sequence([sonidos[0], SKAction.wait(forDuration: 0.4), sonidos[distancia]])
      nodoNota.run(secuenciaSonidos)
    }
  }
  
  /**
   Devuelve un SKEmitterNode que simula una explosión
  */
  class func explosion(intensity: CGFloat) -> SKEmitterNode {
    let emitter = SKEmitterNode()
    let particleTexture = SKTexture(imageNamed: "spark")
    
    emitter.zPosition = 2
    emitter.particleTexture = particleTexture
    emitter.particleBirthRate = 4000 * intensity
    emitter.numParticlesToEmit = Int(400 * intensity)
    emitter.particleLifetime = 2.0
    emitter.emissionAngle = CGFloat(90.0).degreesToRadians()
    emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
    emitter.particleSpeed = 600 * intensity
    emitter.particleSpeedRange = 1000 * intensity
    emitter.particleAlpha = 1.0
    emitter.particleAlphaRange = 0.25
    emitter.particleScale = 1.2
    emitter.particleScaleRange = 2.0
    emitter.particleScaleSpeed = -1.5
    emitter.particleColor = SKColor.orange
    emitter.particleColorBlendFactor = 1
    emitter.particleBlendMode = SKBlendMode.add
    emitter.run(SKAction.removeFromParentAfterDelay(1.0))
    
    return emitter
  }
}
