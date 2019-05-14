//
//  Panel.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 23/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 La clase panel se utiliza como transición entre escenas.
 Un panel permite mostrar un mensaje al usuario, esperar un tiene a que lo lea, y seguir hacia la siguiente tarea
 */
class Panel: SKNode {
    var lblTitulo: SKLabelNode = {
        let label = SKLabelNode(fontNamed: Letras.pizarra)
        label.fontSize = 40.0
        label.fontColor = Colores.indicaciones
        return label
    }()
    var lblDescripcion: SKLabelNode = {
        let label = SKLabelNode(fontNamed: Letras.pizarra)
        label.fontSize = 25.0
        label.fontColor = Colores.indicaciones
        return label
    }()
    var panel: SKShapeNode!
    
    /**
     Crea un panel informativo.
     - Parameter size: tamaño del panel a mostrar,
     - Parameter titulo: texto superior de mayor tamaño,
     - Parameter descripción: texto descriptivo de menor tamaño.
     */
    init(size: CGSize, titulo: String, descripcion: String) {
        panel = SKShapeNode(rect: CGRect(origin: .zero, size: size), cornerRadius: 0.0)
        self.lblTitulo.text = titulo
        self.lblDescripcion.text = descripcion
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupPanel()
        setupTitulo()
        setupDescripcion()
    }
    
    func setupPanel() {
        panel.fillColor = Colores.background
        panel.zPosition = zPositionNodes.panel
    }
    
    func setupTitulo() {
        lblTitulo.position = CGPoint(x:panel.frame.width / 2, y: panel.frame.height / 1.5)
        lblTitulo.preferredMaxLayoutWidth = panel.frame.width - Medidas.marginSpace
        lblTitulo.numberOfLines = 0
        lblTitulo.verticalAlignmentMode = .center
        lblTitulo.horizontalAlignmentMode = .center
    }
    
    func setupDescripcion() {
        lblDescripcion.position = CGPoint(x:panel.frame.width / 2, y: panel.frame.height / 2.5)
        lblDescripcion.preferredMaxLayoutWidth = panel.frame.width - Medidas.marginSpace * 2
        lblDescripcion.numberOfLines = 0
        lblDescripcion.verticalAlignmentMode = .center
        lblDescripcion.horizontalAlignmentMode = .center
    }
    
    /**
     Pone el panel en escena, lo muestra y realiza la acción pasada en completion
     */
    func aparecer(completion: @escaping () -> Void) {
        addChild(panel)
        panel.addChild(lblTitulo)
        panel.addChild(lblDescripcion)
        self.alpha = 0.0
        let secuencia = SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.wait(forDuration: 3.0), SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()])
        self.run(secuencia) {
            completion()
        }
    }
    
    /**
     Pone el panel en escena, lo muestra y realiza la acción pasada en completion.
     Es una versión de la anterior función que sale sin fadeOut
     TODO: refactor: una única función que pasara si se desea fadeOut o no como parámetro
     */
    func aparecerSinFadeout(completion: @escaping () -> Void) {
        addChild(panel)
        panel.addChild(lblTitulo)
        panel.addChild(lblDescripcion)
        self.alpha = 0.0
        let secuencia = SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.wait(forDuration: 3.0)])
        self.run(secuencia) {
            completion()
        }
    }
    
    
}
