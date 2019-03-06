//
//  SceneEditor.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 01/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Scene que permite creación / edición de un patrón
 */

class SceneEditor: SKScene {
    var guitarra: GuitarraViewController!
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
    }
    
    
    func iniciarGuitarra() {
        guitarra = GuitarraViewController(size: size, tipo: .guitarra)
        addChild(guitarra)
        guitarra.poblarMastil()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let tonica = TipoIntervaloMusical.tonica()
        if guitarra.mastil.existeTonica() {
            // averiguar traste pulsado
            if let trastePulsado = guitarra.trastePulsado(touches) {
                // calcular distancia entre tónica y nota pulsada
                if let trasteTonica = guitarra.mastil.encuentraIntervalos(delTipo: tonica).first {
                    if let distancia = guitarra.mastil.distanciaEnSemitonos(traste1: trasteTonica, traste2: trastePulsado) {
                        let intervalos = TipoIntervaloMusical.intervalosConDistancia(semitonos: distancia)
                        print("Intervalos: \(intervalos)")
                    }
                    
                }
            }
        } else { // escribir tónica
            let tipoTraste = TipoTraste.intervalo(tonica)
            guitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste)
        }
        
    }
}
