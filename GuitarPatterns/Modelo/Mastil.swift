//
//  Mastil.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Mastil representa la lógica del mástil de la guitarra
 */
class Mastil {
    private var numCuerdas: Int   // número de cuerdas
    private var numTrastes: Int   // número de trastes
    private var trastes: [[Traste]] = [[Traste]]() //trastes del mástil
    
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
                let traste = Traste(cuerda: x, traste: y, estado: .blanco)
                unaCuerda.append(traste)
            }
            trastes.append(unaCuerda)
        }
        
    }
    
    /**
     Establece el valor de un traste
     - Parameter datosTraste: información del traste a situar en el mástil
     */
    func setTraste(datosTraste: Traste) {
        let posCuerda = datosTraste.getCuerda() - 1 // Array de cuerdas empieza en 0
        let posTraste = datosTraste.getTraste() - 1 // Array de trastes empieza en 0
        var nuevoTraste = datosTraste
        nuevoTraste.setEstado(tipo: datosTraste.getEstado())
        trastes[posCuerda][posTraste] = nuevoTraste
    }
    
    /**
     Coge el valor de un traste si existe. Devuelve nil en caso contrario.
     - Parameter numCuerda: cuerda en la que se está buscando el traste
     - Parameter numTraste: posición del traste que se está buscando dentro de la cuerda.
     */
    func getTraste(numCuerda: TipoPosicionCuerda, numTraste: TipoPosicionTraste) -> Traste? {
        let cuerda = numCuerda - 1 // Array de cuerdas empieza en 0
        
        if cuerda >= 0 && cuerda < trastes.count {
            let traste = numTraste - 1 // Array de trastes empieza en 0
            if traste >= 0 && traste < trastes[cuerda].count {
                return trastes[cuerda][traste]
            }
        }
        return nil
    }
    
    /**
     Asigna un patrón al mástil
     - Parameter patron: patrón a representar
     */
    func setPatron(_ patron: Patron) {
        crearMastilVacio()
        for traste in patron.getTrastes() {
            setTraste(datosTraste: traste)
        }
    }
    
    // MARK: Cálculos armónicos en el mástil
    /**
     Devuelve los semitonos desde el primer traste hasta el segundo
     
     ### ATENCIÓN ###
     Se utiliza la afinación universal basada en una bajada por cuartas (o subida por quintas)
     Tener en cuenta la excepción que existe de un semitono entre segunda y tercera cuerda.
     */
    static func distanciaEnSemitonos(traste1: Traste, traste2: Traste) -> Int? {
        guard traste1.getCuerda() != 0 && traste2.getCuerda() != 0 && traste1.getTraste() != 0 && traste2.getTraste() != 0 else {
            return nil
        }
        // Si los dos trastes son iguales la distancia es de cero (unísono)
        if traste1.getPosicion() == traste2.getPosicion() {
            return 0
        }
        
        // Contamos semitonos debidos al cambio de cuerda
        let cuerdasInvolucradas = abs(traste1.getCuerda() - traste2.getCuerda())
        var semitonos = 0
        if traste1.getCuerda() >= traste2.getCuerda() {
            semitonos = cuerdasInvolucradas * 5 // afinación universal: bajada por cuartas
        } else {
            semitonos = cuerdasInvolucradas * 7 // subida por quintas
        }
        if traste1.getCuerda() <= traste2.getCuerda() {
            if (traste1.getCuerda()...traste2.getCuerda()).contains(3) && (traste1.getCuerda()...traste2.getCuerda()).contains(2) {
                semitonos += 1              // Corrección para 2 cuerda
            }
        } else {
            if (traste2.getCuerda()...traste1.getCuerda()).contains(2) && (traste2.getCuerda()...traste1.getCuerda()).contains(3) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
            
        }
        
        // Ajustamos semitonos que ocurren por desplazamiento en el mástil
        semitonos += traste2.getTraste() - traste1.getTraste()
        let octavaJusta = TipoIntervaloMusical.octavajusta
        if semitonos < 0 { // este caso se da cuando la nota está en la misma cuerda antes que la tónica
            semitonos = octavaJusta.distancia() + semitonos
        }
        
        semitonos = semitonos % octavaJusta.distancia()
        if semitonos == 0 {
            semitonos = octavaJusta.distancia()
        }
        
        return semitonos
    }
    
    
    // MARK: Funciones de búsqueda en el mástil
    
    /**
     Función que busca trastes que contienen notas que cumplen una función interválica concreta
     - Parameter delTipo: tipo de intervalo que estamos buscando
     */
    func encuentraIntervalos(delTipo intervalo: TipoIntervaloMusical) -> [Traste] {
        var resultado = [Traste]()
        for  arrayTrastes in trastes {
            for traste in arrayTrastes {
                if traste.tieneFuncionIntervalica(intervalo) {
                    resultado.append(traste)
                }
            }
        }
        return resultado
    }
    
    
    /**
     Función que examina si existe una nota con función de tónica en el mástil
     La tónica se identifica como un intervalo unísono, es decir, un intervalo de 0 semitonos.
     */
    func existeTonica() -> Bool {
        if encuentraIntervalos(delTipo: .unisono).count > 0 {
            return true
        } else {
            return false
        }
    }
    
    /**
     Busca la primera aparición de la tónica en el mástil
     */
    func trasteTonica() -> Traste? {
        let trastesTonica = encuentraIntervalos(delTipo: .unisono)
        return trastesTonica.count > 0 ? trastesTonica.first : nil
    }
    
    /**
     Crea un nuevo patrón que contiene únicamente los trastes representados en el mástil.
     */
    func getPatron() -> Patron {
        return Patron(trastes: getTrastes())
    }
    
    func getTrastes() -> [Traste] {
        var trastesPatron = [Traste]()
        for (_, arrayTrastes) in trastes.enumerated() {
            for (_, traste) in arrayTrastes.enumerated() {
                if !traste.estaBlanco() {
                    trastesPatron.append(traste)
                }
            }
        }
        return trastesPatron
    }
    
    /**
     Devuelve el número de notas presentes en el mástil
     */
    func lenght() -> Int {
        return getTrastes().count
    }
    
}

// Extensión para obtener una descripción textual del mástil
// Utilizada para depuración.
extension Mastil: CustomStringConvertible {
    var description: String {
        var string = ""
        for (indexCuerda, arrayTrastes) in trastes.enumerated() {
            for (indexTraste, traste) in arrayTrastes.enumerated() {
                let estadoTraste = traste.getEstado()
                string += "[\(indexCuerda), \(indexTraste)]: \(estadoTraste)"
            }
            string += "\n"
        }
        return string
    }
}
