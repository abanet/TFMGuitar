//
//  Mastil.swift
//  GuitarPatternsTests
//
//  Created by Alberto Banet Masa on 7/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import XCTest
@testable import GuitarPatterns

class TestMastil: XCTestCase {

    let mastil  = Mastil(tipo: TipoGuitarra.guitarra)
    var traste1 = Traste(cuerda: 5, traste: 2)
    let traste2 = Traste(cuerda: 6, traste: 1)
    let traste3 = Traste(cuerda: 3, traste: 6)
    let traste4 = Traste(cuerda: 1, traste: 4)
    let traste5 = Traste(cuerda: 1, traste: 2)
    let traste6 = Traste(cuerda: 2, traste: 2)
    let traste7 = Traste(cuerda: 3, traste: 3)
    let traste8 = Traste(cuerda: 6, traste: 6)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDistanciaEnSemitonos() {
        let resultado6 = Mastil.distanciaEnSemitonos(traste1: traste7, traste2: traste8)
        let resultado1 = Mastil.distanciaEnSemitonos(traste1: traste1, traste2: traste2)
        let resultado2 = Mastil.distanciaEnSemitonos(traste1: traste1, traste2: traste3)
        let resultado3 = Mastil.distanciaEnSemitonos(traste1: traste1, traste2: traste4)
        let resultado4 = Mastil.distanciaEnSemitonos(traste1: traste1, traste2: traste1)
        let resultado5 = Mastil.distanciaEnSemitonos(traste1: traste5, traste2: traste6)
        
        
    
      XCTAssert(resultado6 == TipoIntervaloMusical.octavajusta.distancia(), "Error, en lugar de tónica devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado6!).first))")
        
      XCTAssert(resultado1 == TipoIntervaloMusical.quintadisminuida.distancia(), "Error, en lugar de una quinta disminuida devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado1!).first))")
        
      XCTAssert(resultado2 == TipoIntervaloMusical.segundamayor.distancia(), "Error, en lugar de una quinta disminuida devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado2!).first))")
        
      XCTAssert(resultado3 == TipoIntervaloMusical.sextamayor.distancia(), "Error, en lugar de una quinta disminuida devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado3!).first))")
        
      XCTAssert(resultado4 == 0, "Error, en lugar de cero devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado4!).first))")
      
      XCTAssert(resultado5 == TipoIntervaloMusical.quintajusta.distancia(), "Error, en lugar de quinta justa devuelve \(String(describing: TipoIntervaloMusical.intervalosConDistancia(semitonos: resultado5!).first))")
      
    }

    func testEncuentraIntervalo() {
        traste1.setEstado(tipo: TipoTraste.intervalo(TipoIntervaloMusical.tonica()))
        mastil.setTraste(datosTraste: traste1)
        let posicionEncontrada = mastil.encuentraIntervalos(delTipo: TipoIntervaloMusical.tonica()).first?.getPosicion()
        XCTAssert( posicionEncontrada == traste1.getPosicion(), "Error al encontrar intervalo de tónica. La tónica está en \(traste1.getPosicion()), y la encuentra en \(posicionEncontrada)")
    }
}
