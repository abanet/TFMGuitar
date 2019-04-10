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
    
    let menu = SKNode()
    var startLocationX: CGFloat = 0.0
    var moviendo: Bool = false
    
    
    override func didMove(to view: SKView) {
        PatronesDB.share.getPatronesPublica { [unowned self] patrones in
             var x: CGFloat = 0.0
            for n in 1...patrones.count {
                let nuevoPatron = GuitarraStatica(size: CGSize(width: 350, height: 200))
                nuevoPatron.name = "patron\(n)"
                nuevoPatron.dibujarPatron(patrones[n-1])
                nuevoPatron.isUserInteractionEnabled = false
                nuevoPatron.position = CGPoint(x: x, y: 50)
                x += 300
                self.menu.addChild(nuevoPatron)
            }
            self.addChild(self.menu)
            self.menu.name = "menu"
        }
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
                    let nodo = menu.nodes(at:locationMenu).first?.parent as? GuitarraStatica
                    print("Hemos tocado: \(nodo?.name) en \(location)")
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moviendo {
          let location = touch.location(in: self)
          menu.position.x = location.x + startLocationX
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moviendo = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moviendo = false
    }
    
}
