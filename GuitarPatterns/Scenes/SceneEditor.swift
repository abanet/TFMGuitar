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
    var patron: Patron?
    var datosGrabados = false {
        didSet {
            if datosGrabados {
                btnSave.backgroundColor = Colores.botones
            } else {
                btnSave.backgroundColor = UIColor.red
            }
        }
    }

    lazy var btnReset: UIButton = Boton.crearBoton(nombre: "Reset".localizada())
    lazy var btnEditarNombre: UIButton = Boton.crearBoton(nombre: "Editar Nombre".localizada())
    lazy var btnSave: UIButton = Boton.crearBoton(nombre: "Grabar".localizada())
    lazy var btnNuevo: UIButton = Boton.crearBoton(nombre: "Nuevo".localizada())
    lazy var btnSalir: UIButton = Boton.crearBoton(nombre: "Volver".localizada())
    
    var lblNombrePatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nexa-Bold", size: 18.0)
        label.sizeToFit()
        return label
    }()
    var lblCategoriaPatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nexa-Bold", size: 18.0)
        label.sizeToFit()
        return label
    }()
    var lblDescripcionPatron: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NexaBook", size: 16.0)
        label.sizeToFit()
        return label
    }()
        
    init(size: CGSize, patron: Patron?) {
        self.patron = patron
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        // si no hay patrón crear mástil vacío, en otro caso rellenar mástil con el patrón pasado como parámetro: guitarra.dibujarPatron(patron)
        if let patron = patron {
            guitarra.dibujarPatron(patron)
        } else {
            guitarra.crearMastilVacio()
        }
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
            if let distancia = Mastil.distanciaEnSemitonos(traste1: trasteTonica, traste2: trastePulsado) {
              let intervalos = TipoIntervaloMusical.intervalosConDistancia(semitonos: distancia)
              // De momento siempre el primer intervalo encontrado. No tenemos en cuenta enarmónicos.
              let tipoTraste = TipoTraste.intervalo(intervalos.first!)
              guitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste)
              datosGrabados = false
            }
          }
        } else { // existe una nota, hay que eliminarla
          // se podría hacer que al pulsar otra vez alterne con enarmónicos.
          guitarra.marcarNotaTocada(touches, conTipoTraste: .blanco)
            datosGrabados = false
        }
      }
    } else { // No existe tónica. Escribir tónica
      let tipoTraste = TipoTraste.intervalo(tonica)
      guitarra.marcarNotaTocada(touches, conTipoTraste: tipoTraste)
      guitarra.recalcularMastil()
      datosGrabados = false
    }
  }
  
    private func addUserInterfaz(){
        self.view?.addSubview(btnReset)
        self.view?.addSubview(btnEditarNombre)
        self.view?.addSubview(btnSave)
        self.view?.addSubview(btnNuevo)
        self.view?.addSubview(btnSalir)
        
        self.view?.addSubview(lblNombrePatron)
        self.view?.addSubview(lblDescripcionPatron)
        self.view?.addSubview(lblCategoriaPatron)
        
        lblNombrePatron.translatesAutoresizingMaskIntoConstraints = false
        lblDescripcionPatron.translatesAutoresizingMaskIntoConstraints = false
        lblCategoriaPatron.translatesAutoresizingMaskIntoConstraints = false
        
        // cálculos para posicionamiento de 4 botones
        let anchoBoton: CGFloat = (self.view!.frame.width / 5) - Medidas.minimumMargin * 5 - Medidas.minimumMargin * 4
        let posTrailingReset: CGFloat = -(self.view!.frame.width - 5 * anchoBoton - 4 * Medidas.minimumMargin) / 2
        
        btnReset.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnEditarNombre.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnSave.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnNuevo.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnSalir.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        
        lblCategoriaPatron.topAnchor.constraint(equalTo: btnReset.bottomAnchor, constant: Medidas.minimumMargin * 2).isActive = true
        lblNombrePatron.topAnchor.constraint(equalTo: btnReset.bottomAnchor, constant: Medidas.minimumMargin * 2).isActive = true
        lblDescripcionPatron.topAnchor.constraint(equalTo: lblNombrePatron.bottomAnchor, constant: 0).isActive = true
        
        btnReset.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: posTrailingReset).isActive = true
        btnEditarNombre.trailingAnchor.constraint(equalTo: btnReset.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        btnSave.trailingAnchor.constraint(equalTo: btnEditarNombre.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        btnNuevo.trailingAnchor.constraint(equalTo: btnSave.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        btnSalir.trailingAnchor.constraint(equalTo: btnNuevo.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        
        lblCategoriaPatron.leadingAnchor.constraint(equalTo: btnSalir.leadingAnchor).isActive = true
        lblNombrePatron.leadingAnchor.constraint(equalTo: lblCategoriaPatron.trailingAnchor, constant: Medidas.minimumMargin * 2).isActive = true
        lblDescripcionPatron.leadingAnchor.constraint(equalTo: lblCategoriaPatron.leadingAnchor).isActive = true
        
        
        btnReset.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
        btnEditarNombre.widthAnchor.constraint(equalToConstant: anchoBoton).isActive  = true
        btnSave.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
        btnNuevo.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
        btnSalir.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
        
        btnReset.addTarget(self, action: #selector(btnResetPulsado), for: .touchDown)
        btnEditarNombre.addTarget(self, action: #selector(btnEditarNombrePulsado), for: .touchDown)
        btnSave.addTarget(self, action: #selector(btnSavePatronPulsado), for: .touchDown)
        btnNuevo.addTarget(self, action: #selector(btnNuevoPatronPulsado), for: .touchDown)
        btnSalir.addTarget(self, action: #selector(btnSalirPulsado), for: .touchDown)
    }
    
    
    @objc func btnResetPulsado() {
        guitarra.limpiarMastil()
        datosGrabados = true // mástil vacío, no hay datos para grabar por lo que es como si estuvieran grabados.
    }

    @objc func btnEditarNombrePulsado() {
            let vc = EditDataVC()
            vc.nombrePatron = lblNombrePatron.text
            vc.descripcionPatron = lblDescripcionPatron.text
            vc.categoriaPatron = lblCategoriaPatron.text
        
            vc.delegate = self
            vc.view.frame = (self.view?.frame)!
            vc.view.layoutIfNeeded()
            vc.modalTransitionStyle = .flipHorizontal
            self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func btnSavePatronPulsado() {
        // Sólo grabaremos si se cumplen las siguientes condiciones:
        // 1.- existe una tónica en el mástil,
        // 2.- hay más 3 ó más notas en el patrón,
        // 3.- el patrón tiene metadatos asignados para poder almacenarlo en bbdd
        if let tonica = guitarra.mastil.trasteTonica() {
            if guitarra.mastil.lenght() > 2 {
                if patron != nil {
                    patron!.setTrastes(guitarra.mastil.getTrastes())
                    patron!.setTonica(tonica)
                    PatronesDB.share.grabarPatronEnPublica(patron!) { ok in
                        if ok {
                            DispatchQueue.main.async {
                                self.datosGrabados = true
                            }
                            Alertas.mostrar(titulo: "Patrón grabado".localizada(), mensaje: "El patrón se ha grabado en la base de datos.".localizada(), enViewController: self.view!.window!.rootViewController!)
                            
                        }
                    }
                } else {
                    Alertas.mostrar(titulo: "¡Faltan datos!".localizada(), mensaje: "Vaya a editar nombre para asignar el nombre y el tipo del patrón.".localizada(), enViewController: (view!.window!.rootViewController!))
                }
            } else {
                Alertas.mostrar(titulo: "¡Defina un patrón!".localizada(), mensaje: "Un patrón tiene que tener al menos 3 notas asignadas.".localizada(), enViewController: (view!.window!.rootViewController!))
            }
        } else {
            Alertas.mostrar(titulo: "¡Tónica obligatoria!".localizada(), mensaje: "Un patrón tiene que tener una tónica de referencia.".localizada(), enViewController: (view!.window!.rootViewController!))
        }
    }
    
    
    @objc func btnNuevoPatronPulsado() {
        if datosGrabados { // creamos el patrón sin problemas
            establecerNuevoPatron()
        } else {
            Alertas.mostrarOkCancel(titulo: "¡Atención!", mensaje: "Los datos sin grabar se perderán.", enViewController: view!.window!.rootViewController!) {
                alerta in
                self.establecerNuevoPatron()
            }
        }
    }
    
    @objc func btnSalirPulsado() {
        guard let vista = self.scene?.view else {
            return
        }
        vista.eliminarUIKit()
        //let wait = SKAction.wait(forDuration: 2.0)
        let irPatronAction = SKAction.run {
            let escena = SceneMenu(size: self.size)
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))//([wait, irJuegoPatron]))
    }
    
   
    /**
    Esta funcioón se utiliza cuando se ha terminado de trabajar con un patrón y se desea comenzar con uno nuevo.
    Vacía el mástil, elimina el patrón con el que se está trabajando y se cierra el registro de la bbdd.
    */
    func establecerNuevoPatron() {
        guitarra.limpiarMastil()
        resetLabels()
        patron = nil
        PatronesDB.share.cerrarRegistro()
    }
    
    /**
     Resetea los textos de los datos descriptivos del patrón
    */
    func resetLabels() {
        lblNombrePatron.text = ""
        lblCategoriaPatron.text = ""
        lblDescripcionPatron.text = ""
    }
    
    
    
    
 
}

/**
 Implementación del protocolo FormularioDelegate
 */
extension SceneEditor: FormularioDelegate {
    /**
     Se ha completado el formulario con los datos del patrón.
     El patrón ya tiene los metadatos para grabarse, creamos patrón y asignamos datos.
    */
    func onFormularioRelleno(nombre: String, descripcion: String, tipo: String) {
        patron = Patron(nombre: nombre, tipo: tipo)
        patron!.setDescripcion(descripcion)
        lblNombrePatron.text = nombre
        lblDescripcionPatron.text = descripcion
        lblCategoriaPatron.text = tipo 
        datosGrabados = false
    }
}
