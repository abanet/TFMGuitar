//
//  GuitarraView.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 
 Define el tipo de instrumento de cuerda que se va a utilizar.
 El tipo de instrumento definirá el número de cuerdas y la afinación estándar de las mismas.
 */
enum TipoGuitarra {
    case guitarra
    case guitarra7
    case bajo
    case bajo5
    case ukelele
    
    func numeroCuerdas() -> Int {
        switch self {
        case .guitarra:
            return 6
        case .guitarra7:
            return 7
        case .bajo:
            return 4
        case .bajo5:
            return 5
        case .ukelele:
            return 4
        }
    }
}

/**
 
 Vista del mástil del instrumento.
 Se encarga de la representación gráfica del instrumento.
 */
class GuitarraView: SKNode {
    // MARK: propiedades
    var size: CGSize
    var tipo: TipoGuitarra
    
    
    /// Ancho del traste según el ancho de la pantalla
    var anchoTraste: CGFloat {
        get {
            return (size.width - Medidas.marginSpace * 2) / CGFloat(Medidas.numTrastes)
        }
    }
    
    /// Espacio entre cuerdas
    var espacioEntreCuerdas: CGFloat {
        get {
            return (size.height - Medidas.porcentajeTopSpace * size.height - Medidas.bottomSpace) / CGFloat(tipo.numeroCuerdas())
        }
    }
    
    /// Radio de la nota
    var radio: CGFloat {
        get {
            return espacioEntreCuerdas / Medidas.ratioCuerdasNota
        }
    }
    
    /// Posiciones de dibujo de las cuerdas
    var arrayPosicionCuerdas: [CGFloat] = [CGFloat]()
    
    /// Posiciones de los trastes
    lazy var arrayPosicionTrastes: [CGFloat] = {
        var posiciones = [CGFloat]()
        var posicionTraste = Medidas.marginSpace
        for _ in 1...Medidas.numTrastes {
            posiciones.append(posicionTraste)
            posicionTraste += anchoTraste
        }
        posiciones.append(posicionTraste)
        return posiciones
    }()
    
    /// Posiciones en las que se puede situar una nota
    var matrizPosicion: [[CGPoint]] = [[CGPoint]]()
    
    // MARK: Métodos SKNode
    init(size: CGSize, tipo: TipoGuitarra = TipoGuitarra.guitarra) {
        self.size = size
        self.tipo = tipo
        super.init()
        dibujarCuerdas()
        dibujarTrastes()
        calcularMatrizPosicion()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Métodos dibujo de mástil
    
    /**
     Dibuja e identifica las cuerdas del mástil
    */
    func dibujarCuerdas() {
        var posicionCuerda = Medidas.bottomSpace
        for n in (1...tipo.numeroCuerdas()).reversed() {
            arrayPosicionCuerdas.append(posicionCuerda)
            let puntoOrigen  = CGPoint(x: 0, y: posicionCuerda)
            let puntoDestino = CGPoint(x: size.width, y: posicionCuerda)
            let cuerda = StringGuitar(from: puntoOrigen, to: puntoDestino, numCuerda: n)
            addChild(cuerda)
            posicionCuerda += espacioEntreCuerdas
        }
    }
    
    /**
     Dibuja los trastes del mástil.
     Los trastes no intervienen más que a nivel visual.
     */
    func dibujarTrastes() {
        let origenY = arrayPosicionCuerdas[0]
        let finalY  = arrayPosicionCuerdas[tipo.numeroCuerdas() - 1]
        for n in arrayPosicionTrastes {
            let origen = CGPoint(x: n, y: origenY)
            let final  = CGPoint(x: n, y: finalY)
            let traste = SKShapeNode.drawLine(from: origen, to: final)
            traste.strokeColor   = Colores.strings
            traste.lineWidth     = Medidas.widthString
            addChild(traste)
        }
    }
    
    /**
    Añade una nota al mástil de la guitarra en el traste indicado
    */
    func addNotaGuitarra(traste: Traste) {
        let (x,y) = convertirMastilToView(traste: traste)
        let nota = ShapeNota(posicion: traste.getPosicion(), radio: radio)
        nota.getShape().position.x = matrizPosicion[x][y].x
        nota.getShape().position.y = matrizPosicion[x][y].y
        nota.setTraste(traste)
        self.addChild(nota)
    }
    
    /**
     Localiza la vista asociada al traste y si existe nota la actualiza.
     La nota no se crea, simplemente se cambian los valores asociados
    */
    func marcarNotaGuitarra(traste: Traste) {
        let (x,y) = convertirMastilToView(traste: traste)
        for child in self.children {
            if let shapeNota = child as? ShapeNota {
               // if shapeNota.isInPosition(posX: matrizPosicion[x][y].x, posY: matrizPosicion[x][y].y) {
              // TODO: si funciona esto no hay que tener en cuenta la matriz de posiciones
              if let trasteShape = shapeNota.getTraste(), trasteShape.getPosicion() == traste.getPosicion() {
                
                    shapeNota.setTraste(traste)
                    switch traste.getEstado() {
                    case let .nota(nota):
                        shapeNota.setTextNota(nota.getNombreAsText())
                    case let .intervalo(intervalo):
                        shapeNota.setTextNota(intervalo.rawValue)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    /**
     Teniendo en cuenta las dimensiones del mástil se calculan las posiciones en las que vamos a poder situar una nota.
    */
    func calcularMatrizPosicion() {
        for posicionCuerda in arrayPosicionCuerdas {
            var posicionUnaCuerda = [CGPoint]()
            for posicionTraste in arrayPosicionTrastes {
                let posX = posicionTraste + anchoTraste / 2
                let posY = posicionCuerda
                posicionUnaCuerda.append(CGPoint(x: posX, y: posY))
            }
            matrizPosicion.append(posicionUnaCuerda)
        }
    }
    
    
    /**
     Convierte unas coordenadas lógicas de la guitarra en las coordenadas físicas de su representación gráfica.
    */
    func convertirMastilToView(traste: Traste) -> (x: Int, y: Int) {
        // TODO: estamos en pruebas. Ahora mismo no hay conversión
        return (tipo.numeroCuerdas() - traste.getCuerda(), traste.getTraste() - 1)
    }
    
    
    /**
     Responde al toque del usuario.
     Permite la selección de notas
    */
    func marcarNotaTocada(_ touches: Set<UITouch>, conTipoTraste tipo: TipoTraste, completion: @escaping (Traste) -> ()) {
        if let shapeNota = getNotaTocada(touches) {
            if case TipoTraste.blanco = tipo {
                shapeNota.setTipoShapeNote(.unselected)
            } else {
                // Se ha tocado un traste con una nota
                switch shapeNota.getTipo() {
                case .unselected:
                    shapeNota.setTipoShapeNote(.selected)
                case .selected:
                    shapeNota.setTipoShapeNote(.unselected)
                case .tonica:
                    shapeNota.setTipoShapeNote(.unselected)
                }
            }
            if var traste = shapeNota.getTraste() {
                traste.setEstado(tipo: tipo)
                shapeNota.setTraste(traste)
                completion(traste)
            }
        }
    }
    
 
    
    
    /**
     Obtiene el elemento gráfico de la nota que se ha tocado en pantalla
    */
    func getNotaTocada(_ touches: Set<UITouch>) -> ShapeNota? {
        guard let touch = touches.first else {
            return nil
        }
        let touchPosition = touch.location(in: self)
        let touchedNodes  = nodes(at:touchPosition)
        for node in touchedNodes {
            if let miNodo = node as? ShapeNota, node.name == "nota" {
                return miNodo
            }
        }
        return nil
    }
    
    /**
    Obtiene el traste en el que se ha pulsado
    */
    func trastePulsado(_ touches: Set<UITouch>) -> Traste? {
        if let shapeNota = getNotaTocada(touches) {
            print("Traste pulsado: \(shapeNota.getTraste())")
            return shapeNota.getTraste()
        } else {
            return nil
        }
    }
    
}
