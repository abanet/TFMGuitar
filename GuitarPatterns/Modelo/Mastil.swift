//
//  Mastil.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit


class Mastil {
    var numCuerdas: Int
    var numTrastes: Int
    var trastes: [[Traste]] = [[Traste]]()
    
    init(numCuerdas: Int, numTrastes: Int) {
        self.numCuerdas = numCuerdas
        self.numTrastes = numTrastes
        crearMastilVacio()
    }
    
    convenience init(tipo: TipoGuitarra) {
        self.init(numCuerdas: tipo.numeroCuerdas(), numTrastes: Medidas.numTrastes)
    }
    
    /**
     Crea la estructura de trastes que conformarán la parte visible del mástil
     */
    func crearMastilVacio() {
        for x in 0..<numCuerdas {
            var unaCuerda = [Traste]()
            for y in 0..<numTrastes {
                let traste = Traste(cuerda: x, traste: y, estado: .vacio)
                unaCuerda.append(traste)
            }
            trastes.append(unaCuerda)
        }
    }
    
    /**
    Establece el valor de un traste
    */
    func setTraste(datosTraste: Traste) {
        let cuerda = datosTraste.getCuerda() - 1 // Array de cuerdas empieza en 0
        let traste = datosTraste.getTraste() - 1 // Array de trastes empieza en 0
        trastes[cuerda][traste].setEstado(tipo: datosTraste.getEstado())
    }
    
    /**
    Coge el valor de un traste si existe. Devuelve nil en caso contrario.
    */
    func getTraste(numCuerda: TipoPosicionCuerda, numTraste: TipoPosicionTraste) -> Traste? {
        let cuerda = numCuerda - 1 // Array de cuerdas empieza en 0
        
        if cuerda >= 0 && cuerda < trastes.count {
            let traste = numTraste - 1 // Array de trastes empieza en 0
            let cuerdaEntera = trastes[cuerda]
            if traste >= 0 && traste < trastes[cuerda].count {
                return trastes[cuerda][traste]
            }
        }
        return nil
    }
    
}
