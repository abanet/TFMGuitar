//
//  BotonMenuPrincipal.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 13/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
protocol BotonMenuPulsado: class {
    func botonMenuPulsado(opcion: OpcionesMenu) -> Void
}

class BotonMenuPrincipal: SKNode {
    weak var delegate: BotonMenuPulsado?
    var opcion: SKShapeNode
    var image: SKSpriteNode
    var texto: SKLabelNode
    var tipo: OpcionesMenu
    var activado: Bool = false {
        didSet {
            if activado {
                opcion.fillColor = Colores.botonPrincipalOn
            } else {
                opcion.fillColor = Colores.botonPrincipalOff
            }
        }
    }
    
    init(size: CGSize, imagen: String, titulo: String, tipo: OpcionesMenu) {
        opcion = SKShapeNode(rectOf: size, cornerRadius: size.width/10)
        image = SKSpriteNode(imageNamed: imagen)
        texto = SKLabelNode(fontNamed: "Nexa-Bold")
        self.tipo = tipo
        super.init()
        isUserInteractionEnabled = true
        texto.text = titulo
        texto.fontSize = 18
        texto.fontColor = .black//UIColor(red: 91/255, green: 91/255, blue: 95/255, alpha: 1.0)
        texto.position = CGPoint(x: 0, y: -size.height*3/8)
        
        // Ajustar la imágen asociada para que se mantenga proporcionada en el espacio disponible
        var ratio: CGFloat
        if image.size.width >= image.size.height {
            ratio = image.size.width/image.size.height
            image.size = CGSize(width: size.width/2, height: size.width/2/ratio)
        } else {
            ratio = image.size.height/image.size.width
            image.size = CGSize(width: size.width/2/ratio, height: size.height/2)
        }
        
        image.position = CGPoint(x: 0, y: size.height/8)
        
        opcion.fillColor = Colores.botonPrincipalOff
        opcion.strokeColor = .clear
        opcion.addChild(image)
        opcion.addChild(texto)
        addChild(opcion)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activado = true
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activado = false
        delegate?.botonMenuPulsado(opcion: self.tipo)
    }
}
