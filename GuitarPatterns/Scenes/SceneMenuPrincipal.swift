//
//  SceneMenuPrincipal.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 13/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

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
        let opcion1 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "mispatrones", titulo: "Mis Patrones".localizada())
        opcion1.position = CGPoint(x: sextoAncho, y: cuartoAlto)
       
        
        let opcion2 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "editor", titulo: "Editor".localizada())
        opcion2.position = CGPoint(x: sextoAncho * 3, y: cuartoAlto)

        let opcion3 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "logros", titulo: "Logros".localizada())
        opcion3.position = CGPoint(x: sextoAncho * 5, y: cuartoAlto)

        let opcion4 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "acordes", titulo: "Acordes".localizada())
        opcion4.position = CGPoint(x: sextoAncho, y: cuartoAlto * 3)

        let opcion5 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "arpegios", titulo: "Arpegios".localizada())
        opcion5.position = CGPoint(x: sextoAncho * 3, y: cuartoAlto * 3)

        let opcion6 = BotonMenuPrincipal(size: CGSize(width: anchoBoton, height: anchoBoton), imagen: "escalas", titulo: "Escalas".localizada())
        opcion6.position = CGPoint(x: sextoAncho * 5, y: cuartoAlto * 3)
        
        addChild(opcion1);addChild(opcion2)
        addChild(opcion3)
        addChild(opcion4)
        addChild(opcion5)
        addChild(opcion6)
    }
    
}

