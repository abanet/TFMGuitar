//
//  Panel.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 23/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

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
    
    init(size: CGSize, titulo: String, descripcion: String) {
        panel = SKShapeNode(rect: CGRect(origin: .zero, size: size), cornerRadius: 8.0)
        self.lblTitulo.text = titulo
        self.lblDescripcion.text = descripcion
        super.init()
        setup()
        
        //aparecer()
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
        lblDescripcion.position = CGPoint(x:panel.frame.width / 2, y: panel.frame.height / 2)
        lblDescripcion.preferredMaxLayoutWidth = panel.frame.width - Medidas.marginSpace * 2
        lblDescripcion.numberOfLines = 0
        lblDescripcion.verticalAlignmentMode = .center
        lblDescripcion.horizontalAlignmentMode = .center
    }
    
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
    

}
