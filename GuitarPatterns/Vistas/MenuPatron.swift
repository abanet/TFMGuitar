//
//  MenuPatron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 9/4/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit


class MenuPatron: GuitarraView {
    var zonaTactil:SKShapeNode
    
     init(size: CGSize) {
        zonaTactil = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 50), size: size))
        super.init(size: size)
        configurarZonaTactil()
       // deshabilitarGuitarra()
        addChild(zonaTactil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Patron tocado:\(self.name)")
    }
    
    private func deshabilitarGuitarra() {
        for child in self.children {
            child.isUserInteractionEnabled = false
        }
    }
    
    private func configurarZonaTactil() {
        zonaTactil.fillColor = .clear
        zonaTactil.isUserInteractionEnabled = false
        zonaTactil.zPosition  = 10
        zonaTactil.name = "zonatactil"
    }
    
    /**
     Busca la tónica en el mástil y recalcula los intervalos existentes.
     */
    override func dibujarPatron(_ patron: Patron) {
        // Si no existe tónica no se pueden calcular los intervalos
        guard let trasteTonica = patron.getTonica() else {
            return
        }
        var nuevosTrastes = [Traste]()
        for var traste in patron.getTrastes() {
            if let distanciaATonica = Mastil.distanciaEnSemitonos(traste1: trasteTonica, traste2: traste) {
                if let nuevoIntervalo = TipoIntervaloMusical.intervalosConDistancia(semitonos: distanciaATonica).first {
                    traste.setEstado(tipo: TipoTraste.intervalo(nuevoIntervalo))
                    nuevosTrastes.append(traste)
                }
            }
        }
        patron.setTrastes(nuevosTrastes)
        super.dibujarPatron(patron)
    }
    
}
