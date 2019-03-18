//
//  SceneEditor.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 01/03/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
import CoreGraphics


/**
 Scene que permite creación / edición de un patrón
 */

class SceneEditor: SKScene {
    var guitarra: GuitarraViewController!
    
    var btnReset: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.backgroundColor = UIColor.orange
        b.setTitle("Reset", for: UIControl.State.normal)
        return b
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        addBtnReset()
    }
    
    
    /**
     Establece una guitarra gráfica con su mástil asociado.
     El mástil se inicializa con notas en blanco.
    */
    func iniciarGuitarra() {
        let sizeGuitar = CGSize(width: size.width, height: size.height * Medidas.porcentajeAltoMastil)
        guitarra = GuitarraViewController(size: sizeGuitar, tipo: .guitarra)
        addChild(guitarra)
        guitarra.crearMastilVacio()
    }
  
  
  /**
   Control de las pulsaciones sobre la pantalla.
   Al tocar una nota en blanco se escribira:
   - una tónica si esta no existe,
   - el intervalo en relación a la tónica si esta existe.
   - Si se elimina la tónica del patrón y se añade en otro lugar los intervalos seleccionados se recalculan automáticamente.
  */
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let tonica = TipoIntervaloMusical.tonica()
    if guitarra.mastil.existeTonica() {
      // averiguar traste pulsado
      if let trastePulsado = guitarra.trastePulsado(touches) {
        if case TipoTraste.blanco = trastePulsado.getEstado() { //No hay nota, hay que añadirla
          // calcular distancia entre tónica y nota pulsada
          if let trasteTonica = guitarra.mastil.encuentraIntervalos(delTipo: tonica).first {
            if let distancia = guitarra.mastil.distanciaEnSemitonos(traste1: trasteTonica, traste2: trastePulsado) {
              let intervalos = TipoIntervaloMusical.intervalosConDistancia(semitonos: distancia)
              // De momento siempre el primer intervalo encontrado. No tenemos en cuenta enarmónicos.
              let tipoTraste = TipoTraste.intervalo(intervalos.first!)
              guitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste)
            }
          }
        } else { // existe una nota, hay que eliminarla
          // se podría hacer que al pulsar otra vez alterne con enarmónicos.
          guitarra.marcarNotaTocada(touches, conTipoTraste: .blanco)
        }
      }
    } else { // No existe tónica. Escribir tónica
      let tipoTraste = TipoTraste.intervalo(tonica)
      guitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste)
      guitarra.recalcularMastil()
    }
  }
  
    func addBtnReset(){
        self.view?.addSubview(btnReset)
        btnReset.layer.cornerRadius = 20
        btnReset.translatesAutoresizingMaskIntoConstraints = false
        btnReset.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: 30).isActive = true
        btnReset.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: -30).isActive = true
        btnReset.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnReset.addTarget(self, action: #selector(btnResetPulsado), for: .touchDown)
    }
    
    @objc func btnResetPulsado() {
        print("Limpiando mástil")
        guitarra.limpiarMastil()
    }

    
}
