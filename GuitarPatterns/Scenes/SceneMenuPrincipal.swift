//
//  SceneMenuPrincipal.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 13/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
enum OpcionesMenu: String {
    case acordes
    case arpegios
    case escalas
    case mispatrones
    case editor
    case logros
}

class SceneMenuPrincipal: SKScene {

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = .white
        self.setBackground()
        self.crearMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackground() {
        let fondo = SKSpriteNode(imageNamed: "fondoMenuPrincipal")
        fondo.size = size
        fondo.position = CGPoint(x: size.width/2, y: size.height/2)
        fondo.zPosition = zPositionNodes.background
        addChild(fondo)
    }
    
    private func crearMenu() {
        let anchoBoton = size.width / 6 // se divide la pantalla en cuadrícula de 6 x 2 para el diseño
        let sextoAncho = size.width / 6
        let cuartoAlto = size.height / 4
        
        // Menú principal
        let opcion1 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "mispatrones", titulo: "Mis Patrones".localizada(), tipo: OpcionesMenu.mispatrones)
        opcion1.position = CGPoint(x: sextoAncho, y: cuartoAlto)
        opcion1.delegate = self
        
        let opcion2 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "editor", titulo: "Editor".localizada(), tipo: OpcionesMenu.editor)
        opcion2.position = CGPoint(x: sextoAncho * 3, y: cuartoAlto)
        opcion2.delegate = self

        let opcion3 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "logros", titulo: "Logros".localizada(), tipo: OpcionesMenu.logros)
        opcion3.position = CGPoint(x: sextoAncho * 5, y: cuartoAlto)
        opcion3.delegate = self

        let opcion4 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "acordes", titulo: "Acordes".localizada(), tipo: OpcionesMenu.acordes)
        opcion4.position = CGPoint(x: sextoAncho, y: cuartoAlto * 3)
        opcion4.delegate = self

        let opcion5 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "arpegios", titulo: "Arpegios".localizada(), tipo: OpcionesMenu.arpegios)
        opcion5.position = CGPoint(x: sextoAncho * 3, y: cuartoAlto * 3)
        opcion5.delegate = self

        let opcion6 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "escalas", titulo: "Escalas".localizada(), tipo: OpcionesMenu.escalas)
        opcion6.position = CGPoint(x: sextoAncho * 5, y: cuartoAlto * 3)
        opcion6.delegate = self
        
      addChild(opcion1); addChild(opcion2); addChild(opcion3)
      addChild(opcion4); addChild(opcion5); addChild(opcion6)
    }
    
}

extension SceneMenuPrincipal: BotonMenuPulsado {
    func botonMenuPulsado(opcion: OpcionesMenu) {
        switch opcion {
        case .acordes:
            let escena = SceneMenu(size: self.size)
            escena.filtro = TipoPatron.Acorde
            irAEscena(escena)
        case .arpegios:
            let escena = SceneMenu(size: self.size)
            escena.filtro = TipoPatron.Arpegio
            irAEscena(escena)
        case .escalas:
            let escena = SceneMenu(size: self.size)
            escena.filtro = TipoPatron.Escala
            irAEscena(escena)
        case .editor:
            let escena = SceneEditor(size: self.size, patron: nil)
            escena.parentScene = self
            irAEscena(escena)
        case .logros:
            break
        case .mispatrones:
          let escena = SceneMenu(size: self.size)
          escena.privada = true
          irAEscena(escena)
        }
    }
    
    func irAEscena(_ escena: SKScene) {
        let accion = SKAction.run {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([accion]))
    }
}

