//
//  MenuPatron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 9/4/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit


/**
 La guitarra estática deriva de GuitarraView. Tal y como su nombre indica es estática, esto es, no responde a los eventos de los usuarios.
 La utilizaremos para dibujar un patrón de guitarra a nivel meramente informativo, como es el caso del menú de patrones.
 Lo hacemos simplemente añadiendo un primer plano una zona que para las acciones del usuario
 */
class GuitarraStatica: GuitarraView {
    var zonaTactil:SKShapeNode
    
    init(size: CGSize) {
        zonaTactil = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height + Medidas.minimumMargin * 2), cornerRadius: 15.0)
        super.init(size: size)
        configurarZonaTactil()
        self.addChild(zonaTactil)
        zonaTactil.position = CGPoint(x:size.width/2, y:size.height/2 + anchoTraste)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Deshabilita todos los hijos de la vista de la guitarra.
     */
    private func deshabilitarGuitarra() {
        for child in self.children {
            child.isUserInteractionEnabled = false
        }
    }
    
    /**
     Se configura la zona que tapará la guitarra.
     Se desactiva la interacción con el usuario ya que será el propio objeto GuitarraStatica quien reciba los touch.
     */
    private func configurarZonaTactil() {
        zonaTactil.fillColor = .clear
        zonaTactil.strokeColor = .clear
        zonaTactil.isUserInteractionEnabled = false
        zonaTactil.zPosition  = 10
        zonaTactil.name = "zonatactil"
    }
    
    
}
