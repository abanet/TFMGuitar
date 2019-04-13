//
//  BotonMenuPrincipal.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 13/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class BotonMenuPrincipal: SKNode {
    
    init(size: CGSize, imagen: String, titulo: String) {
        super.init()
        let opcion = SKShapeNode(rectOf: size, cornerRadius: size.width/10)
        let image = SKSpriteNode(imageNamed: imagen)
        let texto = SKLabelNode(fontNamed: "Nexa-Bold")
        
        texto.text = titulo
        texto.fontSize = 20
        texto.fontColor = .black//UIColor(red: 91/255, green: 91/255, blue: 95/255, alpha: 1.0)
        texto.position = CGPoint(x: 0, y: -size.height*3/8)
        
        var ratio: CGFloat
        if image.size.width >= image.size.height {
            ratio = image.size.width/image.size.height
            image.size = CGSize(width: size.width/2, height: size.width/2/ratio)
        } else {
            ratio = image.size.height/image.size.width
            image.size = CGSize(width: size.width/2/ratio, height: size.height/2)
        }
        
        image.position = CGPoint(x: 0, y: size.height/8)
        
        opcion.fillColor = UIColor.lightGray.withAlphaComponent(0.35)
        opcion.strokeColor = .clear
        opcion.addChild(image)
        opcion.addChild(texto)
        addChild(opcion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
