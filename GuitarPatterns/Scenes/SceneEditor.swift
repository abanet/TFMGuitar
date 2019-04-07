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

    lazy var btnReset: UIButton = crearBoton(nombre: "Reset".localizada())
    lazy var btnEditarNombre: UIButton = crearBoton(nombre: "Editar Nombre".localizada())
    var nombrePatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nexa-Bold", size: 18.0)
        label.sizeToFit()
        return label
    }()
    var categoriaPatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nexa-Bold", size: 18.0)
        label.sizeToFit()
        return label
    }()
    var descripcionPatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NexaBook", size: 16.0)
        label.sizeToFit()
        return label
    }()
        
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        addUserInterfaz()
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
  
    private func addUserInterfaz(){
        self.view?.addSubview(btnReset)
        self.view?.addSubview(btnEditarNombre)
        self.view?.addSubview(nombrePatron)
        self.view?.addSubview(descripcionPatron)
        self.view?.addSubview(categoriaPatron)
        
        btnReset.layer.cornerRadius = 5
        btnEditarNombre.layer.cornerRadius  = 5
        
        btnReset.translatesAutoresizingMaskIntoConstraints = false
        btnEditarNombre.translatesAutoresizingMaskIntoConstraints  = false
        nombrePatron.translatesAutoresizingMaskIntoConstraints = false
        descripcionPatron.translatesAutoresizingMaskIntoConstraints = false
        categoriaPatron.translatesAutoresizingMaskIntoConstraints = false
        
        btnReset.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnEditarNombre.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        categoriaPatron.bottomAnchor.constraint(equalTo: btnReset.bottomAnchor).isActive = true
        nombrePatron.bottomAnchor.constraint(equalTo: btnReset.bottomAnchor).isActive = true
        descripcionPatron.topAnchor.constraint(equalTo: nombrePatron.bottomAnchor, constant: Medidas.minimumMargin).isActive = true
        //nombrePatron.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        
        btnReset.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: -Medidas.minimumMargin * 2).isActive = true
        btnEditarNombre.trailingAnchor.constraint(equalTo: btnReset.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        categoriaPatron.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: Medidas.minimumMargin * 2).isActive = true
        nombrePatron.leadingAnchor.constraint(equalTo: categoriaPatron.trailingAnchor, constant: Medidas.minimumMargin * 2).isActive = true
        descripcionPatron.leadingAnchor.constraint(equalTo: categoriaPatron.leadingAnchor).isActive = true
        
        btnReset.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnEditarNombre.widthAnchor.constraint(equalToConstant: 150).isActive  = true
        
        btnReset.addTarget(self, action: #selector(btnResetPulsado), for: .touchDown)
        btnEditarNombre.addTarget(self, action: #selector(btnEditarNombrePulsado), for: .touchDown)
    }
    
    
    @objc func btnResetPulsado() {
        print("Limpiando mástil")
        guitarra.limpiarMastil()
    }

    @objc func btnEditarNombrePulsado() {
        if let tonica = guitarra.mastil.trasteTonica() {
            let vc = EditDataVC()
            vc.nombrePatron = nombrePatron.text
            vc.descripcionPatron = descripcionPatron.text
            
            vc.delegate = self
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            vc.modalTransitionStyle = .flipHorizontal
            self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        } else {
            // No hay tónica, no hay patrón
            Alertas.mostrar(titulo: "¡Tónica obligatoria!".localizada(), mensaje: "Un patrón tiene que tener una tónica de referencia.".localizada(), enViewController: (view!.window!.rootViewController!))
        }
    }
    
    @objc func btnSavePatronPulsado() {
        if let tonica = guitarra.mastil.trasteTonica() {
            let patron = guitarra.mastil.getPatron()
            patron.setNombre(nombre)
            patron.setDescripcion(descripcion)
            patron.setTipo(TipoPatron(rawValue: tipo) ?? TipoPatron.Escala)
            patron.setTonica(tonica)
            nombrePatron.text = nombre
            descripcionPatron.text = descripcion
            categoriaPatron.text = tipo + ":"
            //            PatronesDB.share.grabarPatronEnPublica(patron) { ok in
            //                if ok {
            //                    print("Registro grabado")
            //                }
            //            }
        }
    }
    
    private func crearBoton(nombre: String) -> UIButton {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.backgroundColor = UIColor.orange
        b.setTitle(nombre, for: UIControl.State.normal)
        return b
    }
    
    
    
}

/**
 Implementación del protocolo FormularioDelegate
 */
extension SceneEditor: FormularioDelegate {
    
    /**
     Se ha completado el formulario con los datos del patrón.
     Grabamos los datos del patrón en la base de datos
    */
    func onFormularioRelleno(nombre: String, descripcion: String, tipo: String) {
        // tenemos el patrón en el mastil y los datos del patrón. Grabamos los datos a la base de datos.
        if let tonica = guitarra.mastil.trasteTonica() {
            let patron = guitarra.mastil.getPatron()
            patron.setNombre(nombre)
            patron.setDescripcion(descripcion)
            patron.setTipo(TipoPatron(rawValue: tipo) ?? TipoPatron.Escala)
            patron.setTonica(tonica)
            nombrePatron.text = nombre
            descripcionPatron.text = descripcion
            categoriaPatron.text = tipo + ":"
//            PatronesDB.share.grabarPatronEnPublica(patron) { ok in
//                if ok {
//                    print("Registro grabado")
//                }
//            }
        }
    }
    
    
}
