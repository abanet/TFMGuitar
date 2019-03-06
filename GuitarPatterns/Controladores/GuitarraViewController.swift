//
//  GuitarraViewController.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class GuitarraViewController: SKNode {
    var viewGuitarra: GuitarraView!
    var mastil: Mastil!
    var tipo: TipoGuitarra
    
    
    
    init(size: CGSize, tipo: TipoGuitarra) {
        viewGuitarra = GuitarraView(size: size, tipo: tipo)
        mastil       = Mastil(tipo: tipo)
        self.tipo    = tipo
        super.init()
        addChild(viewGuitarra)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func marcarTraste(_ traste: Traste) {
        viewGuitarra.marcarNotaGuitarra(traste: traste)
        mastil.setTraste(datosTraste: traste)
    }
    
    func poblarMastil() {
        for cuerda in 1..<tipo.numeroCuerdas() + 1 {
            for traste in 1..<Medidas.numTrastes + 1 {
                let traste = Traste(cuerda: cuerda, traste: traste, estado: .blanco)
                viewGuitarra.addNotaGuitarra(traste: traste)
            }
        }
        mastil.crearMastilVacio()
    }
    
    func marcarNotaTocada(_ touches: Set<UITouch>, conTipoTraste tipoTraste: TipoTraste) {
        viewGuitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste) {
            [unowned self] traste in
            self.mastil.setTraste(datosTraste: traste)
        }
    }
    
    func posicionPulsada(_ touches: Set<UITouch>) -> PosicionTraste? {
        return viewGuitarra.posicionPulsada(touches)
    }
    
}
