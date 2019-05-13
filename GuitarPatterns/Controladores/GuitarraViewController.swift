//
//  GuitarraViewController.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Controlador del mástil de guitarra.
 Se ocupa de la coordinación entre el mástil (parte lógica de la guitarra) y la vista de la guitarra (GuitarraView)
 */
class GuitarraViewController: SKNode {
    var viewGuitarra: GuitarraView!
    var mastil: Mastil!
    var tipo: TipoGuitarra // en este proyecto se ha trabajado únicamente con guitarras de seis cuerdas.
    
    /**
     Crea una guitarra del tipo indicado y con las dimensiones indicadas.
     */
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
    
    /**
     Marca un traste en la guitarra
     */
    func marcarTraste(_ traste: Traste) {
        viewGuitarra.marcarNotaGuitarra(traste: traste)
        mastil.setTraste(datosTraste: traste)
    }
    
    /**
     Limpia el mástil creando uno con todos los trastes en blanco.
     ###Atencion###
     Los trastes se crean en este momento.
     */
    func crearMastilVacio() {
        for cuerda in 1..<tipo.numeroCuerdas() + 1 {
            for traste in 1..<Medidas.numTrastes + 1 {
                let traste = Traste(cuerda: cuerda, traste: traste, estado: .blanco)
                viewGuitarra.addNotaGuitarra(traste: traste)
            }
        }
    }
    
    /**
     Situa un patrón en el mástil de la guitarra
     */
    func dibujarPatron(_ patron: Patron) {
        self.crearMastilVacio()
        self.viewGuitarra.dibujarPatron(patron)
        self.mastil.setPatron(patron)
    }
    
    
    
    /**
     Busca la tónica en el mástil y recalcula los intervalos existentes.
     Esta función permitirá al usuario cambiar la tónica sin tener que eliminar los intervalos ya existentes.
     Cuando cambia la tónica los intervalos existentes se recalculan.
     */
    func recalcularMastil() {
        // Si no existe tónica no se pueden calcular los intervalos
        guard let trasteTonica = mastil.trasteTonica() else {
            return
        }
        for cuerda in 1..<tipo.numeroCuerdas() + 1 {
            for traste in 1..<Medidas.numTrastes + 1 {
                var trasteActual = mastil.getTraste(numCuerda: cuerda, numTraste: traste)!
                if !trasteActual.estaBlanco() {
                    if let distanciaATonica = Mastil.distanciaEnSemitonos(traste1: trasteTonica, traste2: trasteActual) {
                        if let nuevoIntervalo = TipoIntervaloMusical.intervalosConDistancia(semitonos: distanciaATonica).first {
                            trasteActual.setEstado(tipo: TipoTraste.intervalo(nuevoIntervalo))
                            marcarTraste(trasteActual)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Limpia el mástil poniendo a todas las notas en blanco
     Elimina tanto tónicas como intervalos.
     */
    func limpiarMastil() {
        for cuerda in 1..<tipo.numeroCuerdas() + 1 {
            for traste in 1..<Medidas.numTrastes + 1 {
                var trasteActual = mastil.getTraste(numCuerda: cuerda, numTraste: traste)!
                if !trasteActual.estaBlanco() {
                    trasteActual.setEstado(tipo: TipoTraste.blanco)
                    marcarTraste(trasteActual)
                }
            }
        }
    }
    
    
    /**
     Elimina todas las tónicas de la guitarra.
     */
    func eliminarTonicas() {
        let trastesConTonicas = mastil.encuentraIntervalos(delTipo: .unisono) + mastil.encuentraIntervalos(delTipo: .octavajusta)
        for traste in trastesConTonicas {
            var trasteModificado = traste
            trasteModificado.setEstado(tipo: .blanco)
            marcarTraste(trasteModificado)
        }
    }
    
    /**
     Interpreta el toque de traste del usuario y lo marca en la guitarra
     */
    func marcarNotaTocada(_ touches: Set<UITouch>, conTipoTraste tipoTraste: TipoTraste) {
        viewGuitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste) {
            [unowned self] traste in
            self.mastil.setTraste(datosTraste: traste)
        }
    }
    
    /**
     Interpreta el toque del usuario y devuelve el traste que ha tocado
     */
    func trastePulsado(_ touches: Set<UITouch>) -> Traste? {
        return viewGuitarra.trastePulsado(touches)
    }
    
}
