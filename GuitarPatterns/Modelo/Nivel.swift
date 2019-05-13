//
//  Nivel.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 19/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

/**
 * Define un nivel de dificultad en el juego del reconocimiento de patrones
 *
 * La dificultad del juego se basa en los siguientes modos:
 * -  las notas o intervalos aparecen escritas en el patrón
 * -  las notas o intervalos aparecen coloreados pero sin nota o intervalo escrito.
 * -  sólo aparecen las tónicas
 *
 * Además la dificultad se ve también afectada por:
 * - la velocidad de desplazamiento de las notas
 * - tiempo que tenemos que aguantar en el nivel
 *
 * La combinación de todo lo anterior define un nivel.
 * Se definirán 6 niveles para cada patrón aunque se pueden crear los que se quiera.
 */

/**
 Se definen tres categorías de dificultad
 */
enum NivelDificultad: String {
    case facil
    case intermedio
    case alto
}

/**
 Define los diferentes niveles por los que va a pasar el juego.
 Se definen dos niveles para cada nivel de dificultad. De esta forma en cada categoría de dificultad encontramos dos ejercicios que tendrán las mismas características pero que verán incrementada su dificultad por las variables velocidad y tiempo.
 */
class Nivel {
    
    static let tiempoMinimoRecorrerPantalla: Double = 10.0  // Indica la velocidad máxima de la bola
    static let segundosParaIncrementoVelocidad: Double = 3  // Indica los segundos para incrementar la velocidad
    static let incrementoVelocidad: Int = -2   // Habrá 2 segundos menos para que la bola recorra la pantalla
    static let nivelMaximo = 6
    static let incrementoVelocidadEnAcordes = 7 // los acordes es la figura más sencilla. Subimos la velocidad. Buscamos así equilibrar la velocidad con el nivel de complejidad del tipo de patrón.
    static let incrementoVelocidadEnArpegios = 5 // el arpegio es menos sencillo que el acorde pero más que la escala.
    
    var idNivel: Int
    var tiempoRecorrerPantalla: TimeInterval
    var tiempoJuego: TimeInterval // Tiempo para completar cambio de nivel. 0 para tiempo infinito
    var mostrarTodasLasTonicas: Bool
    var mostrarNotas: Bool // true si se quiere enseñar el texto con los intervalos
    var marcarNotas: Bool   // true si se quiere colorear las notas
    var puntosPorNota: Int!
    var puntosPorIntervalo: Int!
    var descripcion: String
    
    /**
     Se crea un nivel pasando el valor de todas sus variables
     */
    init(idNivel: Int, tiempoPantalla: TimeInterval, tiempoJuego: TimeInterval, mostrarTonicas: Bool, mostrarNotas: Bool, marcarNotas: Bool, descripcion: String = "") {
        self.idNivel = idNivel
        self.tiempoRecorrerPantalla = tiempoPantalla
        self.tiempoJuego = tiempoJuego
        self.mostrarTodasLasTonicas = mostrarTonicas
        self.mostrarNotas = mostrarNotas
        self.marcarNotas = marcarNotas
        self.descripcion = descripcion
        puntosPorNota = idNivel
        puntosPorIntervalo = idNivel * 10
        
    }
    
    /**
     En proceso de depuración nos interesa iniciar el nivel sin presión de tiempo
     */
    convenience init(idNivel: Int, tiempoPantalla: TimeInterval) {
        self.init(idNivel: idNivel, tiempoPantalla: tiempoPantalla, tiempoJuego: 0, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true, descripcion: "")
    }
    
    
    /**
     Obtiene un nivel de dificultad e incorpora variaciones al nivel según el tipo de patrón en el que se esté trabajando.
     De más sencillo a más complicado tenemos: acorde - arpegio - escala
     */
    class func getNivel(_ dificultad: Int, para tipoPatron: TipoPatron) -> Nivel {
        let nivel = getNivel(dificultad)
        switch tipoPatron {
        case .Acorde:
            nivel.decrementarTiempoPantallaEn(incrementoVelocidadEnAcordes)
        case .Arpegio:
            nivel.decrementarTiempoPantallaEn(incrementoVelocidadEnArpegios)
        case .Escala:
            break
        }
        return nivel
    }
    
    /**
     Define los niveles de dificultad del juego,
     - Parameter dificultad: nivel del que se quiere conocer las características.
     */
    class func getNivel(_ dificultad: Int) -> Nivel {
        var nivel: Nivel
        switch dificultad {
        case 1:
            nivel = Nivel(idNivel: 1, tiempoPantalla: 30, tiempoJuego: 60, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true, descripcion: "Comenzamos despacio. Sé consciente de la posición de la tónica y de su posición relativa a cada intervalo que pulsas")
        case 2:
            nivel = Nivel(idNivel: 2, tiempoPantalla: 20, tiempoJuego: 50, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true, descripcion: "Vamos a probar un poco más rápido")
        case 3:
            nivel = Nivel(idNivel: 3, tiempoPantalla: 25, tiempoJuego: 60, mostrarTonicas: true, mostrarNotas: true, marcarNotas: false, descripcion: "¡Vas muy bien! te vamos a quitar el color de las notas que puedes pulsar")
        case 4:
            nivel = Nivel(idNivel: 4, tiempoPantalla: 20, tiempoJuego: 50, mostrarTonicas: true, mostrarNotas: true, marcarNotas: false, descripcion: "Vamos a darle un poco más de caña")
        case 5:
            nivel = Nivel(idNivel: 5, tiempoPantalla: 35, tiempoJuego: 50, mostrarTonicas: true, mostrarNotas: false, marcarNotas: false, descripcion: "Era fácil llegar hasta aquí... creo que ya no necesitas los nombres de los intervalos... 😂😂😂")
        case 6:
            nivel = Nivel(idNivel: 6, tiempoPantalla: 30, tiempoJuego: 40, mostrarTonicas: true, mostrarNotas: false, marcarNotas: false, descripcion: "Nadie ha superado jamás este nivel!! y seguirá siendo así!! 😠😡🤬")
        default:
            nivel = Nivel(idNivel: 1, tiempoPantalla: 40, tiempoJuego: 40, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true, descripcion: "")
        }
        return nivel
    }
    
    
    /**
     Devuelve el siguiente nivel siempre que no se haya llegado al último.
     */
    func siguienteNivel() -> Int {
        if idNivel < 6 {
            return idNivel + 1
        } else {
            return idNivel
        }
    }
    
    // Devuelve la categorización del nivel en la categoría fácil, intermedio, alto
    func getNivelDificultad() -> String {
        if self.idNivel < 3 {
            return NivelDificultad.facil.rawValue
        } else if self.idNivel < 5 {
            return NivelDificultad.intermedio.rawValue
        } else {
            return NivelDificultad.alto.rawValue
        }
    }
    
    /**
     Decrementa la velocidad de las bolas en la cantidad indicada.
     */
    func decrementarTiempoPantallaEn(_ decremento: Int) {
        self.tiempoRecorrerPantalla -= TimeInterval(decremento)
    }
}
