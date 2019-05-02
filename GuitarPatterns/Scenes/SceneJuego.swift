//
//  GameScene.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Escena encargada de jugar con un patrón
//  La escena recibirá un patrón como parámetro y un nivel en el que se va a jugar

import SpriteKit
import GameKit

enum EstadoJuego {
    case jugando
    case pausa
    case partidaperdida
}

class SceneJuego: SKScene {
    var parentScene: SKScene? // escena padre para saber a qué escena volver
    
    
    
    // Guitarra, patrón y nivel para jugar
    var guitarra: GuitarraViewController!
    var patron: Patron! //patrón a aprender
    var nivel: Nivel!
    var efectos: EfectosEspeciales = EfectosEspeciales()
    
    // Notas objetivo
    var notasObjetivo: [ShapeNota] = [ShapeNota]()
    var ultimoObjetivoEscogido: String = "" // para evitar q salgan dos intervalos objetivo seguidos
    var posicionInicial: CGPoint! // Posición de notas examen
    
    var radio: CGFloat { // radio de la nota en el corredor
        get {
            //return (Medidas.topSpace) / 3
            return (Medidas.porcentajeTopSpace * size.height) / 5
        }
    }
    
    var hud = HUD() // head-up display
    var puntos: Int = 0 // puntos que se llevan ganados
    var recordABatir: Int = 0
    var numAciertos: Int = 0 // número de aciertos que lleva el jugador
    
    // variables para control del paso del tiempo
    var lastUpdateTime: TimeInterval = 0  // última vez que se realizo un update del frame
    var dt: TimeInterval = 0 // delta time: tiempo pasado entre dos frames
    var elapsedTime: Int = 0 // tiempo trasncurrido desde el comienzo del juego
    var startTime: Int? //  tiempo en el que se comienza a jugar
    
    // Botón para volver atrás
    var btnVolver: UIButton = Boton.crearBoton(nombre: "Volver".localizada())
    // Rueda dentada
    var ruedaDentada: SKSpriteNode = SKSpriteNode(imageNamed: "ruedaDentada")
    // estado del juego
    var estado = EstadoJuego.pausa

  
    init(size: CGSize, patron: Patron, nivel: Int = 1) {
        self.patron = patron
        self.nivel = Nivel.getNivel(nivel, para: patron.getTipo()!)
        super.init(size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        setupHUD()
        posicionInicial =  CGPoint(x: size.width + Medidas.marginSpace, y: (size.height - Medidas.porcentajeTopSpace * size.height))
        self.estado = .pausa
        empezarJuego()
    }
    
    // Actualización de la escena
    override func update(_ currentTime: TimeInterval) {
        switch estado {
        case .pausa:
            break
        case .jugando:
            // Calcular el deltaTime
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
            } else {
                dt = 0
            }
            lastUpdateTime = currentTime
            updateHUD(currentTime: currentTime)
            // ¿muere alguna nota?
            comprobarDestruccionNotas()
            // ¿se pasa de nivel?
            checkPasoNivel()
        case .partidaperdida:
          estado = .pausa
          partidaPerdida()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchPosition = touch.location(in: self)
        let touchedNodes = nodes(at: touchPosition)
        for node in touchedNodes {
            if let mynode = node as? ShapeNota, node.name == "nota", mynode.getTagNota() != "T" {
                // si hemos acertado sumar un punto y eliminar la primera nota
                if let textoEnNota = mynode.getTagNota(), notasObjetivo.count > 0, textoEnNota == notasObjetivo[0].getTextNota() {
                    // Marcar en verde como que está acertada pero hay q comprobar que no queden más
                    mynode.coloreaCon(UIColor.green)
                    mynode.name = "notaAcertada"
                    animarPuntos(posicion: touchPosition, puntos: nivel.puntosPorNota, dy: 70)
                    puntos += nivel.puntosPorNota
                    efectos.hacerSonarNotaConTonica(mynode)
                    if !quedanNotas(withText: textoEnNota) {
                        // se acertaron todas, eliminar notaObjetivo y restaurar mástil para que todas las notas sean "nota"
                        if let nota = notasObjetivo.first { // acierto
                            nota.coloreaCon(Colores.acierto)
                            animarPuntos(posicion: nota.position, puntos: nivel.puntosPorIntervalo, dy: 20)
                            self.notasObjetivo.remove(at: 0)
                            nota.run(SKAction.afterDelay(0.5) {
                                nota.removeFromParent()
                            })
                            acierto()
                        }
                        let espera = SKAction.wait(forDuration: 0.5)
                        self.isUserInteractionEnabled = false
                        run(espera) {
                            self.restaurarNombresNotasEnMastil()
                            self.isUserInteractionEnabled = true
                        }
                    } else {
                        // aún quedan notas por acertar
                    }
                    
                } else {
                    // colorear en gris para que se vea que se ha utilizado (modo ayuda on)
                    mynode.coloreaCon(Colores.fallo)
                    mynode.name = "notaFallada"
                    animarPuntos(posicion: touchPosition, puntos: -nivel.puntosPorNota, dy: -70)
                    puntos -= nivel.puntosPorNota
                    //fallo()
                }
                
            }
        }
    }
    
    func empezarJuego() {
        let nivelString = "Nivel".localizada() + " " + String(nivel.idNivel)
        if let nombre = patron.getNombre() {
            hud.setTitulo(titulo: nombre + " - " + nivelString, en: CGPoint(x:view!.frame.width / 2, y: view!.frame.height - Medidas.minimumMargin * 3))
        }
        self.restaurarNombresNotasEnMastil()
        self.ajustarMastilNivel()
        hud.updateTimer(time: Int(nivel.tiempoJuego))
        EfectosEspeciales.countdown(desde: 3, enPosicion: CGPoint(x: size.width/2, y: 0), size: size.height/2, nodo: self) {
            self.estado = .jugando
            self.activarSalidaNotas()
        }
      if let tipo = patron.getTipo() {
        recordABatir = Puntuacion.getRecordTipoPatron(tipo)
        hud.updateRecordTo(recordABatir)
      }
      
    }
  
  func partidaPerdida() {
    //reportScoreToGameCenter(score: Int64(puntos))
    // Si se pierde la partida hay que volver al punto de partida
    self.puntos = 0
    self.nivel = Nivel.getNivel(1, para: patron.getTipo()!)
    
    self.removeAction(forKey: "salidaNotas")
    //let eliminarnotas = SKAction.run {self.notasObjetivo.removeAll()}
    let eliminarnotas = SKAction.run {self.eliminarNotasObjetivo()}
    let panelAction = SKAction.run {
      let mensajeNumber = Int.random(in: 0...Mensajes.partidaperdida.count - 1)
      let titulo = Mensajes.partidaperdida[mensajeNumber].localizada()
      let panel = Panel(size: self.size, titulo: titulo , descripcion: "La practica y la constancia son la clave del éxito".localizada())
      self.addChild(panel)
      panel.aparecer() {
        panel.removeFromParent()
        self.resetJuego()
        self.empezarJuego()
      }
    }
    let secuencia = SKAction.sequence([eliminarnotas, panelAction])
    self.run(secuencia)
    //self.run(panelAction)
  }
  
    /**
     Se ha acertado una nota objetivo.
     Incrementamos puntuación
    */
    func acierto() {
        puntos += nivel.puntosPorIntervalo
        numAciertos += 1
    }
    
    /**
     Se ha fallado una nota. Penalizamos restando puntuación.
     */
    func fallo() {
        puntos -= nivel.puntosPorNota
    }
    
    /**
     Establece una guitarra gráfica con su mástil asociado.
     El mástil se inicializa con el patrón pasado como parámetro
     */
    func iniciarGuitarra() {
        guard let patron = patron else { return }
        
        let sizeGuitar = CGSize(width: size.width, height: size.height * Medidas.porcentajeAltoMastil)
        guitarra = GuitarraViewController(size: sizeGuitar, tipo: .guitarra)
        addChild(guitarra)
        guitarra.dibujarPatron(patron)
        self.ajustarMastilNivel()
    }
    
    func ajustarMastilNivel() {
        guitarra.viewGuitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNota,
                let tagNota = shapeNota.getTagNota(),
                tagNota != TipoIntervaloMusical.tonica().rawValue {
                if !self.nivel.marcarNotas {
                    shapeNota.coloreaCon(Colores.noteFill)
                }
                if !self.nivel.mostrarNotas {
                    shapeNota.setTextNota("")
                }
            }
        }
    }
    
    
    
    /**
     Activa la generación de notas de examen.
     Las notas saldrán de forma periodica dependiendo del nivel
     */
    func activarSalidaNotas() {
        let periodo = Double((CGFloat(nivel.tiempoRecorrerPantalla) * (radio * 4)) / size.width)
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnNota()
                }, SKAction.wait(forDuration: periodo)])), withKey: "salidaNotas")
    }
    
    /**
     Comprobación del paso de nivel
    */
    func checkPasoNivel() {
        var patronsuperado = false // ¿se ha superado ya el conocimiento del patrón objetivo?
        if Int(self.nivel.tiempoJuego) - self.elapsedTime <= 0 {
            reportScoreToGameCenter(score: Int64(puntos))
            reportarLogros()
            estado = .pausa
            if self.nivel.idNivel < Nivel.nivelMaximo { // se puede incrementar el nivel
                let siguienteNivel = self.nivel.idNivel + 1
                self.nivel = Nivel.getNivel(siguienteNivel, para: patron.getTipo()!)
            } else { // estamos en el máximo nivel, vamos a darle un poco más de velocidad...
                if self.nivel.tiempoRecorrerPantalla - TimeInterval(Medidas.incrementosVelocidad) > Nivel.tiempoMinimoRecorrerPantalla {
                    self.nivel.decrementarTiempoPantallaEn(Medidas.incrementosVelocidad)
                } else {
                    // Se han superado todas las pruebas con un patrón
                    patronsuperado = true
                    self.removeAction(forKey: "salidaNotas")
                    let eliminarnotas = SKAction.run {self.eliminarNotasObjetivo()}
                    let panelAction = SKAction.run {
                        let titulo = "Figura superada".localizada()
                        let panel = Panel(size: self.size, titulo: titulo , descripcion: "¡A por otra nueva!".localizada())
                        self.addChild(panel)
                        panel.aparecerSinFadeout {
                            self.btnVolverPulsado()
                        }
                    }
                    let secuencia = SKAction.sequence([eliminarnotas, panelAction])
                    self.run(secuencia)
                    
                }
            }
            if !patronsuperado {
                self.removeAction(forKey: "salidaNotas")
                let eliminarnotas = SKAction.run {self.eliminarNotasObjetivo()}
                let panelAction = SKAction.run {
                    let titulo = "Nivel".localizada() + " " + String(self.nivel.idNivel)
                    let panel = Panel(size: self.size, titulo: titulo , descripcion: self.nivel.descripcion)
                    self.addChild(panel)
                    panel.aparecer() {
                        panel.removeFromParent()
                        self.resetJuego()
                        self.empezarJuego()
                    }
                }
                let secuencia = SKAction.sequence([eliminarnotas, SKAction.wait(forDuration: 1.0),panelAction])
                self.run(secuencia)
            }
        }
    }
  
  func comprobarNuevoRecord() -> Bool {
    if self.puntos > self.recordABatir, let tipo = patron.getTipo() {
      self.recordABatir = self.puntos
      Puntuacion.setRecordTipoPatron(tipo, puntos: self.recordABatir)
      hud.blinkRecord()
      return true
    }
    return false
  }
    /**
     Hace un reset del juego
    */
    func resetJuego() {
        //self.puntos = 0
        self.startTime = nil
        self.elapsedTime = 0
        self.lastUpdateTime = 0
        self.dt = 0
    }
    
    /**
     Crea una nueva nota objetivo y la lanza a la pantalla
     */
    func spawnNota() {
        // Creamos la nota
        let nota = ShapeNota(radio: radio)
        nota.name = "notaObjetivo"
        // Asignamos una interválica al azar
        let textNota = obtenerObjetivo()
        nota.setTextNota(textNota)
        nota.setTagNota(textNota)
        // Ponemos la nota en movimiento
        nota.position = posicionInicial
        addChild(nota)
        notasObjetivo.append(nota)
        // movimiento constante
        let actionMove = SKAction.moveTo(x: 0, duration: nivel.tiempoRecorrerPantalla)
        nota.run(actionMove)
    }
    
    /**
     Obtiene el nombre de una nota objetivo.
     Tiene que pertenecer a la interválica del patrón y ser diferente del último objetivo.
     */
    func obtenerObjetivo() -> String  {
        var intervaloElegido: TipoIntervaloMusical
        repeat { // hasta que encontremos un intervalo diferente del último escogido
            repeat { // hasta encontrar en la interválica un intervalo diferente del unísono/octava
                intervaloElegido = patron.getIntervaloAzar()
            } while intervaloElegido == TipoIntervaloMusical.unisono || intervaloElegido == TipoIntervaloMusical.octavajusta
        } while intervaloElegido.rawValue == ultimoObjetivoEscogido
        ultimoObjetivoEscogido = intervaloElegido.rawValue
        return intervaloElegido.rawValue
    }
    
    /**
     Elimina todas las notas objetivo que haya en pantalla.
    */
    func eliminarNotasObjetivo() {
        var pausa = 0.0
        enumerateChildNodes(withName: "notaObjetivo") {[unowned self] (node, _) in
            pausa += 0.2
            let group = SKAction.group([SKAction.fadeAlpha(to:0, duration: 0.4), self.efectos.sonidoPuntos])
            let secuencia = SKAction.sequence([SKAction.wait(forDuration: pausa), group, SKAction.run {
                node.removeFromParent()
                }])
            node.run(secuencia) {
                self.notasObjetivo.removeAll()
            }
        }
        
    }
    
    /**
     Comprueba si hay que destruir algún nodo objetivo
     */
    func comprobarDestruccionNotas() {
        let posFinNotaX = guitarra.viewGuitarra.posicionXTraste(num: Medidas.trasteRuedaDentada)
        enumerateChildNodes(withName: "notaObjetivo") {[unowned self] (node, stop) in
            if node.position.x <= posFinNotaX { // Punto x tope para las bolas
                let down = SKAction.moveTo(y: 0, duration: 1.0)
                let alpha = SKAction.fadeAlpha(to: 0, duration: 1.0)
                let downalpha = SKAction.group([down,alpha])
                node.run(downalpha) {
                    let explosion = EfectosEspeciales.explosion(intensity: 2.0)
                    self.addChild(explosion)
                    explosion.position = node.position
                    node.removeFromParent()
                    if self.notasObjetivo.count > 0 {
                      self.notasObjetivo.remove(at: 0)
                    }
                    if self.estado == .partidaperdida {
                      self.estado = .pausa
                    }
                    if self.estado == .jugando {
                      self.estado = .partidaperdida
                    }
                  
                  
            }
        }
    }
  }
    
    /**
     Devuelve true si quedan notas marcadas como "nota" con el tag pasado como parámetro
     */
    func quedanNotas(withText text: String) -> Bool {
        for child in guitarra.viewGuitarra.children {
            if let nodo = child as? ShapeNota, nodo.name == "nota" {
                if nodo.getTagNota() == text {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Repasa las notas del juego y las nombra como notas normales, reseteando los estados de fallo o acierto que se hayan producido durante el juego.
     */
    func restaurarNombresNotasEnMastil() {
        for child in guitarra.viewGuitarra.children {
            if let shapeNota = child as? ShapeNota, shapeNota.name == "notaFallada" || shapeNota.name == "notaAcertada" {
                shapeNota.name = "nota"
                if shapeNota.getTagNota() != nil && nivel.marcarNotas { // contiene información de nota
                    shapeNota.coloreaCon(Colores.noteFillResaltada)
                } else {
                    shapeNota.coloreaCon(Colores.noteFill)
                }
            }
        }
    }
    
    
    // MARK: Funciones para mantenimiento del HUD
    func setupHUD(){
        guard let view = view, let nivel = nivel else { return }
        let position = CGPoint(x:view.frame.width - Medidas.marginSpace, y: view.frame.height - Medidas.minimumMargin * 3)
        addChild(hud)
        // Timer
        hud.addTimer(time: Int(nivel.tiempoJuego), position: position)
        // nombre + nivel
        let nivelString = "Nivel".localizada() + " " + String(nivel.idNivel)
        if let nombre = patron.getNombre() {
             hud.setTitulo(titulo: nombre + " - " + nivelString, en: CGPoint(x:view.frame.width / 2, y: view.frame.height - Medidas.minimumMargin * 3))
        }
        // Descripción
        if let descripcion = patron.getDescripcion() {
            hud.add(message: descripcion, position: CGPoint(x:view.frame.width / 2, y: view.frame.height - Medidas.minimumMargin * 6))
        }
        // Marcador
        hud.addPuntos(position: CGPoint(x:view.frame.width - Medidas.marginSpace * 3, y: view.frame.height - Medidas.minimumMargin * 6))
        hud.addRecord(position: CGPoint(x:view.frame.width - Medidas.marginSpace, y: view.frame.height - Medidas.minimumMargin * 6))
        setupBotonVolver()
        setupRuedaDentada()
        
    }
    
    func updateHUD(currentTime: TimeInterval) {
        if let startTime = startTime {
            elapsedTime = Int(currentTime) - startTime
        } else {
            startTime = Int(currentTime) - elapsedTime
        }
        hud.updateTimer(time: Int(nivel.tiempoJuego) - elapsedTime)
        hud.updatePuntosTo(puntos)
      if comprobarNuevoRecord() {
        hud.updateRecordTo(puntos)
      }
    }
    
    // Volver a la pantalla origen
    @objc func btnVolverPulsado() {
        guard let vista = self.scene?.view else {
            return
        }
        acumularPartida()
        vista.eliminarUIKit()
        let irPatronAction = SKAction.run {
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(self.parentScene!, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))//([wait, irJuegoPatron]))
    }
    
    func setupBotonVolver() {
        btnVolver.addTarget(self, action: #selector(btnVolverPulsado), for: .touchDown)
        self.view?.addSubview(btnVolver)
        btnVolver.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin).isActive = true
        btnVolver.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: Medidas.minimumMargin * 3).isActive = true
        btnVolver.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupRuedaDentada() {
        ruedaDentada.position = CGPoint(x: guitarra.viewGuitarra.posicionXTraste(num: Medidas.trasteRuedaDentada), y: (size.height - Medidas.porcentajeTopSpace * size.height))
        ruedaDentada.scale(to: CGSize(width: radio * 2, height: radio * 2))
        //ruedaDentada.scale(to: CGSize(width: 50, height: 50))
        let girar = SKAction.rotate(byAngle: .pi * 2, duration: 5)
        let girarForever = SKAction.repeatForever(girar)
        ruedaDentada.run(girarForever)
        addChild(ruedaDentada)
    }
    
    /**
     Añade una etiqueta animada con los puntos ganados sobre una nota.
    */
    func animarPuntos(posicion: CGPoint, puntos: Int, dy: Int) {
        let scoreLabel = SKLabelNode(fontNamed: Letras.puntosNota)
        scoreLabel.fontColor = Colores.noteFillResaltada
        scoreLabel.fontSize = 20
        scoreLabel.text = String(puntos)
        scoreLabel.position = posicion
        scoreLabel.zPosition = 500
        
        self.addChild(scoreLabel)
        let moveAction = SKAction.move(by: CGVector(dx: 2, dy: dy), duration: 1.0)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()])) {
            self.efectos.hacerSonarPuntos(nodo: scoreLabel)
        }
        
    }
    
    // MARK: GameCenter
    // Funciones de llamada al GameCenter
    
    /**
     Envía una puntuación al GameCenter.
     Los paneles de puntuación se categorizan por el tipo de patrón y el nivel de dificultad.
    */
    func reportScoreToGameCenter(score: Int64) {
        if let tipo = patron.getTipo()?.rawValue {
          let id = "\(tipo)_\(nivel.getNivelDificultad())"
            GameKitHelper.sharedInstance.reportScore(
                score: score,
                forLeaderboardID: TableroPuntuaciones.ID[id]!)
        }
    }
    
    // Si se han conseguido los puntos mínimos necesarios se acumula una partida.
    // La acumulación de partidas se utiliza para conseguir el logro de la constancia
    func acumularPartida() {
        if puntos > Puntuacion.minimoConsideradoPartida {
            // acumulamos una nueva partida
            let acumuladas = Puntuacion.getPartidasAcumuladas() + 1
            Puntuacion.setPartidasAcumuladas(acumuladas)
        }
    }
    
    func reportarLogros() {
        var logros: [GKAchievement] = [GKAchievement]()
        
        let partidasAcumuladas = Puntuacion.getPartidasAcumuladas()
        let hardworkerLogro = LogrosHelper.HardWorkerLogro(partidas: partidasAcumuladas)
        logros.append(hardworkerLogro)
        if let tipo = patron.getTipo(), let logroNivel = LogrosHelper.logroParaTipoPatron(tipoPatron: tipo, puntos: puntos) {
            logros.append(logroNivel)
        }
        
        GameKitHelper.sharedInstance.reportAchievements(achievements: logros)
        
    }
}
