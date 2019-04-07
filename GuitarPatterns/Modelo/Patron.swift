//
//  Patron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 10/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

enum TipoPatron: String {
    case Escala
    case Arpegio
    case Acorde
}


class Patron {
    
    private var nombre: String? // nombre del patrón
    private var descripcion: String? // descripción del patrón
    private var tipo: TipoPatron?
    
    private var trastes: [Traste] = [Traste]()
    private var tonica: Traste?
    
    init(trastes: [Traste]) {
        self.trastes  = trastes
        
    }
    
    func addTraste(_ traste: Traste) {
        trastes.append(traste)
    }
    
    func getNombre() -> String? {
        return nombre
    }
    
    func setNombre(_ nombre: String) {
        self.nombre = nombre
    }
    
    func getDescripcion() -> String? {
        return descripcion
    }
    
    func setDescripcion(_ nombre: String) {
        self.descripcion = nombre
    }
    
    func getTipo() -> TipoPatron? {
        return tipo
    }
    
    func setTipo(_ tipo: TipoPatron) {
        self.tipo = tipo
    }
    
    func getTonica() -> Traste? {
        return tonica
    }
    
    func setTonica(_ tonica: Traste) {
        self.tonica = tonica
    }
    
    /**
     Indica si un patrón está completo o no.
     Un patrón está completo si tiene al menos dos trastes, una tónica, y el tipo y nombre definidos.
    */
    func estaCompleto() -> Bool {
        guard (nombre != nil), (descripcion != nil), (tonica != nil), (tipo != nil) else {
            return false
        }
        return trastes.count > 1
    }
    
    
    /**
     Codifica la sucesión de trastes en un formato de arrays de enteros.
     El objetivo de esto es simplificar el proceso de grabación en iCloud, ya que el array de Int es uno de los tipos contemplados.
     La codificación es muy simple: un traste consta de una posición formada por el número de cuerda y el número de traste. Crearemos un entero resultante de la concatenación de la cuerda y el traste, es decir:
     TrasteCodificado = número de cuerda * 10 + número de traste. (Ej: cuerda 5, traste 3 -> 53)
     */
    func codificarTrastes() -> [Int] {
        var trastesCodificados = [Int]()
        for traste in trastes {
            let codificacion = traste.codificar()
            trastesCodificados.append(codificacion)
        }
        return trastesCodificados
    }

    
    
    /**
    Codifica la tónica del patrón
    */
    func codificarTonica() -> Int {
        if let tonica = self.tonica {
            return tonica.codificar()
        } else {
            return 0
        }
    }
    
    /**
     Decodifica un array de enteros en trastes.
     - Parameter trastesCodificados: Array con enteros
     ### ATENCIÓN ###
     *Cuidado* la decodificación implica la pérdida de los trastes que pudieran existir en el patrón
     */
    func decodificarTrastes(trastesCodificados: [Int]) {
        var arrayTrastes = [Traste]()
        for x in trastesCodificados {
            let traste = Traste.decodificar(x)
            arrayTrastes.append(traste)
        }
        self.trastes.removeAll()
        self.trastes = arrayTrastes
    }
    
    
    
    /**
     Decodifica la tónica modificando la tónica del patrón.
     ### ATENCIÓN ###
     *Cuidado* Modifica la tónica del patrón
    */
    func decodificaTonica(_ trasteCodificado: Int) {
        self.tonica = Traste.decodificar(trasteCodificado)
    }
    
}