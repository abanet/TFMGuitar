//
//  EfectosEspaciales.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Clase que reune los 'efectos especiales' utilizados en el juego.
 Realiza la gestión del sonido, las explosiones y la cuenta atrás.
 */
class EfectosEspeciales {
    // Sonidos
    let sonidoPuntos = SKAction.playSoundFileNamed("collectcoin.wav", waitForCompletion: true)
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
        // cargamos los sonidos para no tener tiempos de latencia a la hora de lanzarlos
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
    
    /**
     Hace sonar un intervalo musical: primero la tónica y después el intervalo.
     TODO: Actualmente se trabaja sólo con intervalos y la tónica siempre tiene el mismo sonido.
     En un futuro se tiene que poder elegir la tónica y trabajar con notas en lugar de con intervalos.
     */
    func hacerSonarNotaConTonica(_ nodoNota: ShapeNota) {
        if let distanciaTonica = nodoNota.getTraste()?.getIntervalo()?.distancia()  {
            let distancia = distanciaTonica % 12
            let secuenciaSonidos = SKAction.sequence([sonidos[0], SKAction.wait(forDuration: 0.4), sonidos[distancia]])
            nodoNota.run(secuenciaSonidos)
        }
    }
    
    /**
     Sonido cuando conseguimos puntos
     */
    func hacerSonarPuntos(nodo: SKNode) {
        let volumenAction = SKAction.changeVolume(by: 3.0, duration: 0.7)
        let sonidoConVolumen = SKAction.group([sonidoPuntos, volumenAction])
        nodo.run(sonidoConVolumen)
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
    
    /**
     Cuenta atrás en pantalla
     */
    class func countdown(desde: Int, enPosicion posicion: CGPoint, size: CGFloat, nodo: SKNode, completion: @escaping () -> Void) {
        let label = SKLabelNode(fontNamed: Letras.negrita)
        label.position = posicion
        label.fontColor = SKColor.white.withAlphaComponent(1.0)
        label.fontSize = size
        label.zPosition = zPositionNodes.foreground
        label.text = String(desde)
        nodo.addChild(label)
        var contador = desde
        let creceryesperar = SKAction.group([SKAction.fadeOut(withDuration: 1.0), SKAction.scale(by: 3.0, duration: 1.0)])
        let decrementoAction = SKAction.sequence([creceryesperar, SKAction.run { contador -= 1
            label.text = String(contador)
            label.alpha = 1.0
            label.setScale(1.0)
            }])
        label.run(SKAction.repeat(decrementoAction, count: contador + 1)) {
            label.removeFromParent()
            completion()
        }
    }
    
    
}
