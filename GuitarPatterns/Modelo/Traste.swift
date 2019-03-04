//
//  Traste.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Define un traste del instrumento.
//  Incorpora la lógica interválica de la geometría del mástil.
//
//  Se entiende por traste la parte de la cuerda sobre la que se puede pulsar para hacer sonar una nota.

import Foundation

typealias TipoPosicionCuerda = Int
typealias TipoPosicionTraste = Int


/**
 Un incremento define un salto de un traste a otro.
 Un incremento supone una subida o bajada de cuerta y/o una subida o bajada de traste.
 */
struct Incremento {
    let cuerda: Int
    let traste: Int
}

/**
 El traste es un contenedor que puede albergar o no una nota
 */
enum TipoTraste {
    /// El traste no tiene contenido
    case vacio
    /// El traste no tiene contenido pero se mostrará igualmente
    case blanco
    /// El traste tiene
    case nota(Nota)
}

/**
 Almacena una posición de traste en formato cuerda, traste.
 Incluye funciones matemáticas para el cálculo de trastes a partir de la suma de intervalos así como la inversión de intervalos.
 */
struct Traste {
    var cuerda: TipoPosicionCuerda
    var traste: TipoPosicionTraste
    var estado: TipoTraste
    
    init(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste, estado: TipoTraste = .vacio) {
        self.cuerda = cuerda
        self.traste = traste
        self.estado = estado
    }
    
    // Cualquier traste de una cuerda dada
    init(cuerda: TipoPosicionCuerda, estado: TipoTraste) {
        self.init(cuerda: cuerda, traste: 0, estado: estado)
    }
    
    // Cualquier cuerda para un traste dado
    init(traste: TipoPosicionTraste, estado: TipoTraste) {
        self.init(cuerda: 0, traste: traste, estado: estado)
    }
    
    
    
    /**
     Devuelve la posición de traste resultado de sumar un incremento al traste actual.
     
     - Parameter inc: incremento en cuerda y traste a realizar
     */
    func mover(_ inc: Incremento) -> Traste {
        return(Traste(cuerda: cuerda + inc.cuerda, traste: traste + inc.traste))
    }
    
    /**
     
     Devuelve los semitonos desde el traste actual hasta la posición indicada.
     
     - Parameter posicion: traste final
     
     ### ATENCIÓN ###
     Se utiliza la afinación universal basada en una bajada por cuartas (o subida por quintas)
     Tener en cuenta la excepción que existe de un semitono entre segunda y tercera cuerda.
     */
    func semitonosHasta(posicion: Traste) -> Int? {
        guard self.cuerda != 0 && self.traste != 0 else {
            return nil
        }
        
        // Cálculo de semitonos por cuerda
        let cuerdasInvolucradas = abs(self.cuerda - posicion.cuerda)
        var semitonos = 0
        if self.cuerda >= posicion.cuerda {
            semitonos = cuerdasInvolucradas * TipoIntervaloMusical.cuartajusta.distancia() // afinación universal: bajada por cuartas
        } else {
            semitonos = cuerdasInvolucradas * TipoIntervaloMusical.quintajusta.distancia() // subida por quintas
        }
        if self.cuerda <= posicion.cuerda {
            if (self.cuerda...posicion.cuerda).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
        } else {
            if (posicion.cuerda...self.cuerda).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
            
        }
        
        // Cálculo de semitonos por traste
        semitonos += posicion.traste - self.traste
        let octavaJusta = TipoIntervaloMusical.octavajusta
        if semitonos < 0 { // este caso se da cuando la nota está en la misma cuerda antes que la tónica. Subimos una octava
            semitonos = octavaJusta.distancia() + semitonos
        }
        
        semitonos = semitonos % octavaJusta.distancia()
        if semitonos == 0 {
            semitonos = octavaJusta.distancia()
        }
        
        return semitonos
    }
}


