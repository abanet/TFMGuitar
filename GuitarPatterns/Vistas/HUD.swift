//
//  HUD.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 22/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Construimos el head-up display para el juego

import SpriteKit

enum HUDSettings {
    static let font = Letras.normal //"Noteworthy-Bold"
    static let fontSize: CGFloat = 18
}

class HUD: SKNode {
    
    var timerLabel: SKLabelNode?    // Tiempo restante
    var puntosLabel: SKLabelNode?   // puntuación conseguida
    var lblTitulo: SKLabelNode?
    
    override init() {
        super.init()
        name = "HUD"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitulo(titulo: String, en posicion: CGPoint) {
        if let label = lblTitulo { // existe título
            label.text = titulo
        } else { // creamos título nuevo
            lblTitulo = SKLabelNode(fontNamed: HUDSettings.font)
            lblTitulo!.text = titulo
            lblTitulo!.name = titulo
            lblTitulo!.zPosition = zPositionNodes.foreground
            lblTitulo!.fontSize = HUDSettings.fontSize
            lblTitulo!.position = posicion
            addChild(lblTitulo!)
        }
    }
    
    func add(message: String, position: CGPoint,
             fontSize: CGFloat = HUDSettings.fontSize) {
        let label: SKLabelNode
        label = SKLabelNode(fontNamed: HUDSettings.font)
        label.text = message
        label.name = message
        label.zPosition = zPositionNodes.foreground
        addChild(label)
        label.fontSize = fontSize
        label.position = position
    }
    
    func updateTimer(time: Int) {
        guard time >= 0 else { return }
        let minutes = (time/60) % 60
        let seconds = time % 60
        let timeText = String(format: "%02d:%02d", minutes, seconds)
        timerLabel?.text = timeText
    }
    
    func addTimer(time: Int, position: CGPoint) {
        guard scene != nil else { return }
        add(message: "Timer", position: position, fontSize: 18)
        timerLabel = childNode(withName: "Timer") as? SKLabelNode
        timerLabel?.verticalAlignmentMode = .bottom
        timerLabel?.fontName = Letras.contador //"Menlo"
        updateTimer(time: time)
    }
    
    func addPuntos(position: CGPoint) {
        guard scene != nil else { return }
        add(message: "Puntos", position: position, fontSize: 18)
        puntosLabel = childNode(withName: "Puntos") as? SKLabelNode
        puntosLabel?.verticalAlignmentMode = .bottom
        puntosLabel?.fontName = Letras.contador
        puntosLabel?.text = "000000"
    }
    
    func updatePuntosTo(_ puntos: Int) {
        puntosLabel?.text = String(format: "%06d", puntos)
    }
    
    func eliminar() {
        self.removeFromParent()
    }
}
