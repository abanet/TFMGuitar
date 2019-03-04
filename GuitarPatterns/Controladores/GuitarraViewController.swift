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
    
    
    
    init(size: CGSize, tipo: TipoGuitarra) {
        viewGuitarra = GuitarraView(size: size, tipo: tipo)
        mastil       = Mastil(tipo: tipo)
        
        super.init()
        addChild(viewGuitarra)
        
        let traste = Traste(cuerda: 6, traste: 1, estado: .vacio)
        marcarTraste(traste)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func marcarTraste(_ traste: Traste) {
        let (x,y) = convertirMastilToView(traste: traste)
        viewGuitarra.dibujarNotaGuitarra(x: x, y: y, tipo: traste.estado)
    }
    
    func convertirMastilToView(traste: Traste) -> (x: Int, y: Int) {
        // TODO: estamos en pruebas. Ahora mismo no hay conversión
        return (traste.cuerda - 1, traste.traste - 1)
    }
}
