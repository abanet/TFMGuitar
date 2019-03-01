//
//  GuitarraView.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 
 Define el tipo de instrumento de cuerda que se va a utilizar.
 El tipo de instrumento definirá el número de cuerdas y la afinación de las mismas.
 */
enum TipoGuitarra {
    case guitarra
    case guitarra7
    case bajo4
    case bajo5
    case ukelele
    case violin
    case charango
    
    func numeroCuerdas() ->
}

class GuitarraView: SKNode {
    /// Tamaño de la vista que contendrá el mástil
    var size: CGSize
    var tipo: TipoGuitarra
    
    
    init(size: CGSize, tipo: TipoGuitarra = TipoGuitarras.guitarra) {
        self.size = size
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawNeck() {
        var positionString = Medidas.bottomSpace
        for _ in 1...Medidas.
    }
}
