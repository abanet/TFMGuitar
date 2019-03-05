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
 Un salto define un movimiento en el mástil.
 El movimiento puede ser horizontal, vertical o una suma de los dos.
 Un salto implica una subida o bajada de cuerta y/o una subida o bajada de traste.
 */
struct Salto {
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
    private var posicion: PosicionTraste
    private var tipo: TipoTraste
    
    init(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste, estado: TipoTraste = .vacio) {
        self.posicion = PosicionTraste(cuerda: cuerda, traste: traste)
        self.tipo = estado
    }
    
    // Cualquier traste de una cuerda dada
    init(cuerda: TipoPosicionCuerda, estado: TipoTraste) {
        self.init(cuerda: cuerda, traste: 0, estado: estado)
    }
    
    // Cualquier cuerda para un traste dado
    init(traste: TipoPosicionTraste, estado: TipoTraste) {
        self.init(cuerda: 0, traste: traste, estado: estado)
    }
    
    // Devuelve la cuerda en la que se posiciona el traste
    func getCuerda() -> TipoPosicionCuerda {
        return posicion.cuerda
    }
    
    // Devuelve la altura del traste
    func getTraste() -> TipoPosicionTraste {
        return posicion.traste
    }
    
    // Devuelve la posición del traste
    func getPosicion() -> PosicionTraste {
        return posicion
    }
    
    // Devuelve el estado del traste
    func getEstado() -> TipoTraste {
        return tipo
    }
    
    // Establece el estado del traste
    mutating func setEstado(tipo: TipoTraste) {
        self.tipo = tipo
    }
    
    /**
     Devuelve la posición de traste resultado de sumar un incremento al traste actual.
     
     - Parameter inc: incremento en cuerda y traste a realizar
     */
    func mover(_ inc: Salto) -> Traste {
        return(Traste(cuerda: self.getCuerda() + inc.cuerda, traste: self.getTraste() + inc.traste))
    }
    
    /**
     Devuelve los semitonos desde el traste actual hasta la posición indicada.
     
     - Parameter posicion: traste final
     
     ### ATENCIÓN ###
     Se utiliza la afinación universal basada en una bajada por cuartas (o subida por quintas)
     Tener en cuenta la excepción que existe de un semitono entre segunda y tercera cuerda.
     */
    func semitonosHasta(nuevoTraste: Traste) -> Int? {
        guard self.getCuerda() != 0 && self.getTraste() != 0 else {
            return nil
        }
        
        // Cálculo de semitonos por cuerda
        let cuerdasInvolucradas = abs(self.getCuerda() - nuevoTraste.getCuerda())
        var semitonos = 0
        if self.getCuerda() >= nuevoTraste.getCuerda() {
            semitonos = cuerdasInvolucradas * TipoIntervaloMusical.cuartajusta.distancia() // afinación universal: bajada por cuartas
        } else {
            semitonos = cuerdasInvolucradas * TipoIntervaloMusical.quintajusta.distancia() // subida por quintas
        }
        if self.getCuerda() <= nuevoTraste.getCuerda() {
            if (self.getCuerda()...nuevoTraste.getCuerda()).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
        } else {
            if (nuevoTraste.getCuerda()...self.getCuerda()).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
            
        }
        
        // Cálculo de semitonos por traste
        semitonos += nuevoTraste.getTraste() - self.getTraste()
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

/**
 Almacena una posición de traste en formato cuerda, traste.
 Incluye funciones matemáticas para el cálculo de trastes a partir de la suma de intervalos
 */
struct PosicionTraste: Equatable {
    var cuerda: TipoPosicionCuerda
    var traste: TipoPosicionTraste
    
    init(cuerda: TipoPosicionCuerda) {
        self.cuerda = cuerda
        self.traste = 0
    }
    
    init(traste: TipoPosicionCuerda) {
        self.traste = traste
        self.cuerda = 0
    }
    
    init(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste) {
        self.cuerda = cuerda
        self.traste = traste
    }
    
    
    
    // MARK: Equatable Protocol
    static func == (lhs: PosicionTraste, rhs: PosicionTraste) -> Bool {
        return lhs.cuerda == rhs.cuerda &&
            lhs.traste == rhs.traste
    }
}


