//
//  SceneMenu.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit


/**
 Clase encargada de generar un menú que permite elegir entre diferentes patrones
*/
class SceneMenu: SKScene {
    var patrones: [Patron] = [Patron]() // patrones por los que vamos a navegar
    var patronSeleccionado: Int? // posición del patrón seleccionado
    
    let menu = SKNode()
    var startLocationX: CGFloat = 0.0
    var maxPosXMenu: CGFloat = 0.0
    var moviendo: Bool = false
    
    var lblNombrePatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "Nexa-Bold"
        return label
    }()
    var lblDescripcionPatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "NexaBook"
        return label
    }()
    var lblNumPatrones: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "NexaBook"
        label.text = "0"
        return label
    }()
    
    lazy var btnDelete: UIButton = Boton.crearBoton(nombre: "Eliminar".localizada())
    lazy var btnEditar: UIButton = Boton.crearBoton(nombre: "Editar Patron".localizada())
    lazy var btnNuevo: UIButton = Boton.crearBoton(nombre: "Nuevo".localizada())
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        crearMenuGrafico()
        addUserInterfaz()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let locationMenu = touch.location(in: menu)
            if menu.contains(location) {
                moviendo = true
                startLocationX = menu.position.x - location.x
                print(menu.nodes(at:locationMenu).first?.name)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moviendo {
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
    
    private func crearMenuGrafico() {
        PatronesDB.share.getPatronesPublica { [unowned self] patrones in
            self.crearMenuGrafico(conPatrones: patrones)
        }
    }
    
    private func crearMenuGrafico(conPatrones patrones: [Patron]) {
        eliminarMenu() // Antes de crear el menú eliminamos el que pudiera existir
        var x: CGFloat = 0.0
        for n in 1...patrones.count {
            let nuevoPatron = GuitarraStatica(size: CGSize(width: self.size.width/2.2, height: self.size.height/2.2))
            nuevoPatron.name = "\(n)"
            nuevoPatron.dibujarPatron(patrones[n-1])
            nuevoPatron.isUserInteractionEnabled = false
            nuevoPatron.position = CGPoint(x: x, y: 0)
            x += self.size.width/2.5// + self.size.width/25 // dejamos un espacio extra de margen
            self.menu.addChild(nuevoPatron)
            self.patrones.append(patrones[n-1])
        }
        self.maxPosXMenu = x
        self.addChild(self.menu)
        self.menu.name = "menu"
        self.menu.position.y = Medidas.bottomSpace
    }
    
    private func eliminarMenu() {
        menu.removeAllChildren()
        menu.removeFromParent()
    }
    
    private func addUserInterfaz() {
        self.view?.addSubview(btnNuevo)
        self.view?.addSubview(btnDelete)
        self.view?.addSubview(btnEditar)
        addChild(lblNumPatrones)
        addChild(lblNombrePatron)
        addChild(lblDescripcionPatron)
        
        // Cálculo de dimensiones y posiciones para 3 botones
        let anchoBoton: CGFloat = (self.view!.frame.width / 3) - Medidas.minimumMargin * 3 - Medidas.minimumMargin * 2
        let posTrailingReset: CGFloat = -(self.view!.frame.width - 3 * anchoBoton - 3 * Medidas.minimumMargin) / 2
        
        btnNuevo.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin * 3).isActive = true
        btnEditar.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin * 3).isActive = true
        btnDelete.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin * 3).isActive = true
        
        btnNuevo.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: posTrailingReset).isActive = true
        btnDelete.trailingAnchor.constraint(equalTo: btnNuevo.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        btnEditar.trailingAnchor.constraint(equalTo: btnDelete.leadingAnchor, constant: -Medidas.minimumMargin).isActive = true
        
        btnNuevo.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
        btnEditar.widthAnchor.constraint(equalToConstant: anchoBoton).isActive  = true
        btnDelete.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
       
        
        btnDelete.addTarget(self, action: #selector(btnDeletePulsado), for: .touchDown)
        btnEditar.addTarget(self, action: #selector(btnEditarPulsado), for: .touchDown)
        btnNuevo.addTarget(self, action: #selector(btnNuevoPulsado), for: .touchDown)
        
        lblNombrePatron.position = CGPoint(x: self.view!.frame.width/2, y: Medidas.bottomSpace + Medidas.minimumMargin)
        lblDescripcionPatron.position = CGPoint(x: self.view!.frame.width/2, y: lblNombrePatron.position.y - Medidas.minimumMargin * 3)
        
        resetDatosPatron()
    }
    
    private func resetDatosPatron() {
        lblNombrePatron.text = "Selecciona un patrón".localizada()
        lblDescripcionPatron.text = "y pulsa sobre el para empezar a trabajar.".localizada()
    }
    
    /**
     Elimina el patrón seleccionado de la base de datos.
    */
    @objc func btnDeletePulsado() {
        if let indice = patronSeleccionado  {
            Alertas.mostrarOkCancel(titulo: "¡Atención!", mensaje: "El patrón seleccionado se borrará de su base de datos de patrones.", enViewController: view!.window!.rootViewController!) {
                [unowned self] alerta in
                // Eliminar registro de la base de datos
                if let id = self.patrones[indice].getId() {
                    PatronesDB.share.eliminarRegistroPublica(id: id)
                    self.patrones.remove(at: indice)
                    self.crearMenuGrafico(conPatrones: self.patrones)
                    DispatchQueue.main.async {
                        self.resetDatosPatron()
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
            irAPatron(patrones[indice])
        }
    }
    
    /**
     Va al editor de patrones para crear un nuevo patrón
     */
    @objc func btnNuevoPulsado() {
        irAPatron(nil)
    }
    
    private func actualizarDatosPatron(indice: Int) {
        lblNombrePatron.text = patrones[indice].getNombre()
        lblDescripcionPatron.text = patrones[indice].getDescripcion()
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
    
    private func irAPatron(_ patron: Patron?) {
        guard let vista = self.scene?.view else {
            return
        }
        vista.eliminarUIKit()
        //let wait = SKAction.wait(forDuration: 2.0)
        let irPatronAction = SKAction.run {
            let escena = SceneEditor(size: self.size, patron: patron)
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))//([wait, irJuegoPatron]))
    }
    
    
}
