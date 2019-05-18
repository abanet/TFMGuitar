//
//  SceneMenu.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
import CloudKit


/**
 Clase encargada de generar un menú que permite elegir entre diferentes patrones
 */
class SceneMenu: SKScene {
    var patronSeleccionado: Int? // posición del patrón seleccionado
    var numeroPatrones: Int = 0
    
    let menu = SKNode()
    var startLocationX: CGFloat = 0.0
    var maxPosXMenu: CGFloat = 0.0
    var moviendo: Bool = false
    var filtro: TipoPatron? // tipo de patrones a mostrar. Por defecto todos (nil)
    var patronesFiltrados: [Patron]?
    var privada: Bool = false // estamos trabajando con patrones publicos o privados?
    
    var lblNombrePatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "Nexa-Bold"
        return label
    }()
    var lblDescripcionPatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = Letras.normal
        return label
    }()
    
    
    var indicadorActividad: UIActivityIndicatorView = {
        let indicador = UIActivityIndicatorView()
        indicador.color = .green
        indicador.style = UIActivityIndicatorView.Style.whiteLarge
        return indicador
    }()
    
    var btnDelete: UIButton = Boton.crearBoton(nombre: "Eliminar".localizada())
    var btnEditar: UIButton = Boton.crearBoton(nombre: "Editar Patron".localizada())
    var btnNuevo: UIButton = Boton.crearBoton(nombre: "Nuevo".localizada())
    var btnVolver: UIButton = Boton.crearBoton(nombre: "Volver".localizada())
    var btnAdd: UIButton = Boton.crearBoton(nombre: "Añadir".localizada())
    var btnJugar: UIButton = Boton.crearBoton(nombre: "Jugar".localizada())
    var btnShare: UIButton = Boton.crearBoton(nombre: "Compartir".localizada())
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Entramos en el menu. Según estemos trabajando en datos públicos o privados adaptamos el menú.
     */
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        crearMenuGrafico()
        if privada {
            addUserInterfaz(botones: [btnVolver, btnEditar, btnDelete, btnNuevo, btnJugar])
            //addUserInterfaz(botones: [btnVolver, btnShare, btnEditar, btnDelete, btnNuevo, btnJugar])
        } else {
            addUserInterfaz(botones: [btnVolver, btnJugar])
            //addUserInterfaz(botones: [btnVolver, btnAdd, btnJugar])
        }
        // Atentos a la llegada de posibles sugerencias por parte de otros usuarios.
        NotificationCenter.default.addObserver(self, selector: #selector(onRecibidaSugerenciaPatron(_:)), name: .recibidaSugerenciaPatron , object: nil)
    }
    
    /**
     Detección de la selección del usuario.
     Al tocar una opción (patrón) se mostrarán los metadatos del mismo
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let locationMenu = touch.location(in: menu)
            if menu.contains(location) {
                moviendo = true
                startLocationX = menu.position.x - location.x
                if menu.nodes(at:locationMenu).first?.name == "zonatactil" {
                    if let nodo = menu.nodes(at:locationMenu).first?.parent as? GuitarraStatica,
                        let indicePatronElegido = Int(nodo.name!) {
                        actualizarDatosPatron(indice: indicePatronElegido - 1)
                        patronSeleccionado = indicePatronElegido - 1
                    }
                }
            }
        }
    }
    
    /**
     Detectar desplazamiento del dedo y desplazar menú en consonancia
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moviendo, numeroPatrones > Int(Medidas.numeroPatronesEnPantalla) {
            let location = touch.location(in: self)
            menu.position.x = location.x + startLocationX
            // vigilamos que el menú no desborde la pantalla por la izquierda
            if menu.position.x > 0 {
                menu.position.x = 0
            }
            // vigilamos que el menú no desborde la pantalla por la derecha
            if menu.position.x < -maxPosXMenu + size.width {
                menu.position.x = -maxPosXMenu + size.width
            }
        }
    }
    
    /**
     Crea el menú gráfico con los patrones correspondientes según en qué base de datos estemos trabajando y los filtros aplicados.
     */
    private func crearMenuGrafico() {
        if privada {
            PatronesDB.share.getPatronesPrivada { [unowned self] patrones in
                self.stopIndicadorActividad()
                self.crearMenuGrafico(conPatrones: patrones)
                self.numeroPatrones = patrones.count
            }
        } else {
            PatronesDB.share.getPatronesPublica { [unowned self] patrones in
                self.stopIndicadorActividad()
                if let filtro = self.filtro {
                    self.patronesFiltrados = patrones.filter {patron in patron.getTipo() == filtro}
                    self.crearMenuGrafico(conPatrones: self.patronesFiltrados ?? [])
                    self.numeroPatrones = self.patronesFiltrados?.count ?? 0
                } else {
                    self.crearMenuGrafico(conPatrones: patrones)
                    self.numeroPatrones = patrones.count
                }
            }
        }
    }
    
    /**
     Función genérica que crea un menú gráfico con los patrones pasados como parámetro.
     */
    private func crearMenuGrafico(conPatrones patrones: [Patron]) {
        eliminarMenu() // Antes de crear el menú eliminamos el que pudiera existir
        var x: CGFloat = 0.0
        if patrones.count > 0 {
            for n in 1...patrones.count {
                let nuevoPatron = GuitarraStatica(size: CGSize(width: self.size.width/(Medidas.numeroPatronesEnPantalla + 0.2), height: self.size.height/(Medidas.numeroPatronesEnPantalla + 0.2)))
                nuevoPatron.name = "\(n)"
                nuevoPatron.dibujarPatron(patrones[n-1])
                nuevoPatron.isUserInteractionEnabled = false
                nuevoPatron.position = CGPoint(x: x, y: 0)
                x += self.size.width/(Medidas.numeroPatronesEnPantalla + 0.5) // dejamos un espacio extra de margen
                self.menu.addChild(nuevoPatron)
            }
            self.maxPosXMenu = x
            self.addChild(self.menu)
            self.menu.name = "menu"
            self.menu.position.y = Medidas.bottomSpace
            refrescarNumeroPatrones(patrones.count)
        }
    }
    
    /**
     Elimina todos los objetos que conforman el menú.
     */
    private func eliminarMenu() {
        menu.removeAllChildren()
        menu.removeFromParent()
    }
    
    /**
     Incorpora el hud
     */
    private func addUserInterfaz(botones:[UIButton]) {
        // Cálculo de dimensiones y posiciones para n botones
        let numBotones = CGFloat(botones.count)
        let maxAnchoBoton = self.view!.frame.width / numBotones
        let totalEspacioEntreBotones = Medidas.minimumMargin * (numBotones + 1)
        let anchoBoton: CGFloat = maxAnchoBoton - Medidas.minimumMargin * 2
        let totalEspacioBotones = numBotones * anchoBoton
        let posLeading: CGFloat = ((self.view!.frame.width - totalEspacioBotones - totalEspacioEntreBotones) / 2) + Medidas.minimumMargin
        
        // Añadir los botones a la vista principal
        for boton in botones {
            self.view?.addSubview(boton)
        }
        // Posicionar botones
        for (indice, boton) in botones.enumerated() {
            boton.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin * 3).isActive = true
            boton.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
            if indice == 0 {
                boton.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: posLeading).isActive = true
            } else {
                boton.leadingAnchor.constraint(equalTo: botones[indice-1].trailingAnchor, constant: Medidas.minimumMargin).isActive = true
            }
        }
        
        // Asociamos acciones
        btnDelete.addTarget(self, action: #selector(btnDeletePulsado), for: .touchDown)
        btnEditar.addTarget(self, action: #selector(btnEditarPulsado), for: .touchDown)
        btnNuevo.addTarget(self, action: #selector(btnNuevoPulsado), for: .touchDown)
        btnVolver.addTarget(self, action: #selector(btnVolverPulsado), for: .touchDown)
        btnAdd.addTarget(self, action: #selector(btnAddPulsado), for: .touchDown)
        btnJugar.addTarget(self, action: #selector(btnJugarPulsado), for: .touchDown)
        btnShare.addTarget(self, action: #selector(btnSharePulsado), for: .touchDown)
        
        // Indicador
        indicadorActividad.center = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY)
        indicadorActividad.startAnimating()
        self.view?.addSubview(indicadorActividad)
        
        // Añadimos etiquetas
        addChild(lblNombrePatron)
        addChild(lblDescripcionPatron)
        
        lblNombrePatron.position = CGPoint(x: self.view!.frame.width/2, y: Medidas.bottomSpace + Medidas.minimumMargin)
        lblDescripcionPatron.position = CGPoint(x: self.view!.frame.width/2, y: lblNombrePatron.position.y - Medidas.minimumMargin * 3)
        
        resetDatosPatron()
    }
    
    private func resetDatosPatron() {
        lblNombrePatron.text = "Selecciona un patrón".localizada()
        lblDescripcionPatron.text = "y pulsa sobre la opción deseada del menú.".localizada()
    }
    
    
    private func refrescarNumeroPatrones(_ num: Int) {
        if num > 0, let filtro = filtro?.rawValue {
            lblNombrePatron.text = "Selecciona un patrón".localizada() + " (\(num) \(filtro) \("disponibles".localizada()))"
        }
    }
    
    // MARK: Acciones de botones
    /**
     Elimina el patrón seleccionado de la base de datos.
     */
    @objc func btnDeletePulsado() {
        if let indice = patronSeleccionado  {
            Alertas.mostrarOkCancel(titulo: "¡Atención!", mensaje: "El patrón seleccionado se borrará de su base de datos de patrones.", enViewController: view!.window!.rootViewController!) {
                [unowned self] alerta in
                // Eliminar registro de la base de datos
                if self.privada {
                    if let id = PatronesDB.share.cachePatronesPrivada[indice].getId() { // existe en la bbdd
                        PatronesDB.share.eliminarRegistroPrivada(id: id)
                        self.crearMenuGrafico(conPatrones: PatronesDB.share.cachePatronesPrivada)
                        DispatchQueue.main.async {
                            self.resetDatosPatron()
                        }
                    } else { // no tiene id pq se acaba de crear. Eliminar de la caché.
                        PatronesDB.share.eliminarRegistroCachePrivada(indice: indice)
                        self.crearMenuGrafico(conPatrones: PatronesDB.share.cachePatronesPrivada)
                        DispatchQueue.main.async {
                            self.resetDatosPatron()
                        }
                    }
                } else {
                    if let id = PatronesDB.share.cachePatronesPublica[indice].getId() {
                        PatronesDB.share.eliminarRegistroPublica(id: id)
                        self.crearMenuGrafico(conPatrones: PatronesDB.share.cachePatronesPublica)
                        DispatchQueue.main.async {
                            self.resetDatosPatron()
                        }
                    }
                }
            }
        }
        
    }
    
    /**
     Llama a la escena de edición con el patrón seleccionado
     */
    @objc func btnEditarPulsado() {
        if let indice = patronSeleccionado {
            if self.privada {
                irAPatron(PatronesDB.share.cachePatronesPrivada[indice])
            } else {
                if self.filtro == nil {
                    irAPatron(PatronesDB.share.cachePatronesPublica[indice])
                } else {
                    irAPatron(patronesFiltrados![indice])
                }
            }
        }
    }
    
    /**
     Va al editor de patrones para crear un nuevo patrón
     */
    @objc func btnNuevoPulsado() {
        irAPatron(nil)
    }
    
    /**
     Regresa a la pantalla del menú principal
     */
    @objc func btnVolverPulsado() {
        guard let vista = self.scene?.view else {
            return
        }
        vista.eliminarUIKit()
        removeAllChildren()
        
        let accion = SKAction.run {
            let escena = SceneMenuPrincipal(size: self.size)
            //vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([accion]))
    }
    
    /**
     Añade el botón a la base de datos privada del usuario
     */
    @objc func btnAddPulsado() {
        guard !privada else { return } // estamos en la pública con total seguridad.
        if let indice = patronSeleccionado { // existe un patrón seleccionado
            var patron: Patron
            if filtro == nil {
                patron = PatronesDB.share.cachePatronesPublica[indice]
            } else {
                patron = patronesFiltrados![indice]
            }
            patron.setRegistro(nil)
            PatronesDB.share.cerrarRegistro() // obligamos a añadir un nuevo registro
            PatronesDB.share.grabarPatronEnPrivada(patron) {
                grabado in
                if grabado {
                    PatronesDB.share.setPatronesPrivadaToNil() // para obligar a recargar
                    DispatchQueue.main.async {
                        Alertas.mostrar(titulo: "Patron Añadido".localizada(), mensaje: "El patrón seleccionado se ha añadido a la lista de tus patrones.".localizada(), enViewController: self.view!.window!.rootViewController!)
                    }
                }
            }
        } else {
            Alertas.mostrar(titulo: "Selecciona un patrón".localizada(), mensaje: "Para poder añadir un patrón en tu sección 'Mis Patrones' tienes que tenerlo seleccionado".localizada(), enViewController: self.view!.window!.rootViewController!)
        }
    }
    
    /**
     Compartir el patron seleccionado con otro usuario.
     Para compartir un registro hay que coger un patrón de la privada y crear un registro compartido.
     */
    @objc func btnSharePulsado(){
        guard privada else { return } // sólo se pueden compartir registros de la privada
        let patronToShare: Patron
        if let indice = patronSeleccionado { // existe un patrón seleccionado
            patronToShare = PatronesDB.share.cachePatronesPrivada[indice]
            PatronesDB.share.privateDB.fetch(withRecordID: patronToShare.getId()!) {
                registro, error in
                if let registro = registro {
                    let share = CKShare(rootRecord: registro)
                    share[CKShare.SystemFieldKey.title] = patronToShare.getNombre()! as CKRecordValue?
                    let controller = UICloudSharingController {
                        controller, preparationCompletionHandler in
                        let saveOperation = CKModifyRecordsOperation(recordsToSave: [registro, share], recordIDsToDelete: nil)
                        saveOperation.modifyRecordsCompletionBlock = {
                            records, recordIds, error in
                            preparationCompletionHandler(share, CKContainer.default(), error)
                        }
                        PatronesDB.share.privateDB.add(saveOperation)
                    }
                    controller.delegate = self
                    controller.availablePermissions = [.allowReadWrite, .allowPrivate]
                    self.view!.window!.rootViewController!.present(controller, animated: true)
                }
            }
        } else {
            Alertas.mostrar(titulo: "Selecciona un patrón".localizada(), mensaje: "Elige el patrón que quieres compartir.".localizada(), enViewController: self.view!.window!.rootViewController!)
        }
    }
    
    /**
     Entra en la escena de juego para el patron seleccionado
     */
    @objc func btnJugarPulsado() {
        if let indice = patronSeleccionado { // existe un patrón seleccionado
            if self.privada {
                jugarPatron(PatronesDB.share.cachePatronesPrivada[indice])
            } else {
                if self.filtro == nil {
                    jugarPatron(PatronesDB.share.cachePatronesPublica[indice])
                } else {
                    jugarPatron(patronesFiltrados![indice])
                }
            }
        } else {
            Alertas.mostrar(titulo: "Selecciona un patrón".localizada(), mensaje: "Elige el patrón que quieres practicar.".localizada(), enViewController: self.view!.window!.rootViewController!)
        }
    }
    
    /**
     Actualiza el hud con los datos del patrón seleccionado y marca dicho patrón con un rectángulo.
     */
    private func actualizarDatosPatron(indice: Int) {
        if privada {
            lblNombrePatron.text = PatronesDB.share.cachePatronesPrivada[indice].getNombre()
            lblDescripcionPatron.text = PatronesDB.share.cachePatronesPrivada[indice].getDescripcion()
        } else {
            if filtro == nil {
                lblNombrePatron.text = PatronesDB.share.cachePatronesPublica[indice].getNombre()
                lblDescripcionPatron.text = PatronesDB.share.cachePatronesPublica[indice].getDescripcion()
            } else {
                lblNombrePatron.text = patronesFiltrados?[indice].getNombre()
                lblDescripcionPatron.text = patronesFiltrados?[indice].getDescripcion()
            }
            
        }
        for (index, opcion) in menu.children.enumerated() {
            if let opcion = opcion as? GuitarraStatica {
                if index == indice {
                    opcion.zonaTactil.fillColor = UIColor.orange.withAlphaComponent(0.3)
                } else {
                    opcion.zonaTactil.fillColor = .clear
                }
            }
        }
    }
    
    /**
     Transición para editar el patrón seleccionado
     */
    private func irAPatron(_ patron: Patron?) {
        guard let vista = self.scene?.view else {
            return
        }
        // UIKit y SpriteKit van independientes. Tenemos siempre que eliminar los hijos de la view y los de la skview!
        vista.eliminarUIKit()
        removeAllChildren()
        let irPatronAction = SKAction.run {
            let escena = SceneEditor(size: self.size, patron: patron)
            escena.parentScene = self // para saber a que escena volver
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))//([wait, irJuegoPatron]))
    }
    
    /**
     Transición y a jugar con el patrón pasado como parámetro
     */
    private func jugarPatron(_ patron: Patron?) {
        guard let vista = self.scene?.view, let patron = patron else {
            return
        }
        vista.eliminarUIKit()
        removeAllChildren()
        let irPatronAction = SKAction.run {
            let escena = SceneJuego(size: self.size, patron: patron, nivel: 1)
            escena.parentScene = self // para saber a que escena volver
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))
    }
    
    
    fileprivate func stopIndicadorActividad() {
        DispatchQueue.main.async {
            self.indicadorActividad.stopAnimating()
        }
    }
    
    /**
     Si se recibe una sugerencia mientras estamos en mis patrones se añade automáticamente. Recargamos el menú.
     */
    @objc func onRecibidaSugerenciaPatron(_ notification: Notification) {
        print("recibidaSugerenciaPatron")
        guard let vista = self.scene?.view else {
            return
        }
        if privada { // en la pública no aceptamos sugerencias.
            // Lanzamos la escena de nuevo. El nuevo  patrón habrá sido incluido si el usuario lo aceptó al recibirlo.
            DispatchQueue.main.async {
                vista.eliminarUIKit()
                self.removeAllChildren()
                self.didMove(to: self.view!)
            }
        }
    }
}

extension SceneMenu: UICloudSharingControllerDelegate {
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Fallo al grabar Share: \(error)")
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        if let indice = patronSeleccionado {
            return PatronesDB.share.cachePatronesPrivada[indice].getNombre()
        } else {
            return nil
        }
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
        let image = UIImage(named:"AppIcon")
        return image?.pngData()
    }
    
}
