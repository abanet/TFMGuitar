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
 Tipo traste define si el traste está en blanco, si tiene una nota(Nota) o si tiene un intervalo(TipoIntervaloMusical)
 */
enum TipoTraste {
    /// El traste no tiene contenido pero se mostrará igualmente
    case blanco
    /// El traste contiene una nota
    case nota(Nota)
    /// El traste contiene un intervalo
    case intervalo(TipoIntervaloMusical)
}

/**
 Almacena una posición de traste en formato cuerda, traste.
 Incluye funciones matemáticas para el cálculo de trastes a partir de la suma de intervalos así como la inversión de intervalos.
 */
struct Traste {
    private var posicion: PosicionTraste
    private var tipo: TipoTraste
    
    init(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste, estado: TipoTraste = .blanco) {
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
    
    // Devuelve la nota del traste, nil en caso contrario
    func getNota() -> Nota? {
        if case let TipoTraste.nota(nota) = tipo {
            return nota
        } else {
            return nil
        }
    }
    
    // Devuelve el intervalo del traste, nil en caso contrario
    func getIntervalo() -> TipoIntervaloMusical? {
        if case let TipoTraste.intervalo(intervalo) = tipo {
            return intervalo
        } else {
            return nil
        }
    }
    
    // Indica si el traste está en blanco o no
    func estaBlanco() -> Bool {
        if case TipoTraste.blanco = tipo {
            return true
        } else {
            return false
        }
    }
    
    
    /**
     Devuelve la posición de traste resultado de sumar un incremento al traste actual.
     
     - Parameter inc: incremento en cuerda y traste a realizar
     */
    func mover(_ inc: Salto) -> Traste {
        return(Traste(cuerda: self.getCuerda() + inc.cuerda, traste: self.getTraste() + inc.traste))
    }
    
    /**
     Indica si el traste tiene una nota que cumple una función interválica determinada
     */
    func tieneFuncionIntervalica(_ funcion: TipoIntervaloMusical) -> Bool {
        if case let .intervalo(intervalo) = tipo, intervalo == funcion { // traste con nota
            return true
        } else {
            return false
        }
    }
    
    /**
     Codifica un traste
     */
    func codificar() -> Int {
        let posicionTraste = self.getPosicion()
        let codificacion = posicionTraste.cuerda * 10 + posicionTraste.traste
        return codificacion
    }
    
    /**
     Decodifica un Int a su equivalente traste
     */
    static func decodificar(_ trasteCodificado: Int) -> Traste {
        return Traste(cuerda: Int(trasteCodificado/10) , traste: trasteCodificado % 10, estado: .blanco)
    }
    
}



/**
 Almacena una posición de traste en formato cuerda, traste.
 Incluye funciones matemáticas para el cálculo de trastes a partir de la suma de intervalos
 */
struct PosicionTraste: Equatable {
    var cuerda: TipoPosicionCuerda
    var traste: TipoPosicionTraste
    
    /// Cualquier traste de una cuerda
    init(cuerda: TipoPosicionCuerda) {
        self.cuerda = cuerda
        self.traste = 0
    }
    
    /// Un traste determinado en cualquier cuerda
    init(traste: TipoPosicionCuerda) {
        self.traste = traste
        self.cuerda = 0
    }
    
    /// Posición determinada y única de cuerda y traste
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


