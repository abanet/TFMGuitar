//
//  Puntuacion.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 24/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

/**
 Clase encargada de escribir y recuperar las puntuaciones del usuario en local.
 Se almacenan los siguientes datos:
 - la puntuación total del usuario a lo largo del tiempo para premiar la constancia
 - la puntuación record del usuario para cada tipo de patrón (acordes, escalas, arpegios)
 */
class Puntuacion {
    static let idRecordAcordes  = "recordAcordes"
    static let idRecordArpegios = "recordArpegios"
    static let idRecordEscalas  = "recordEscalas"
    static let idPartidasAcumuladas = "partidasAcumuladas"
    // TODO: poner valor coherente de mínimo
    static let minimoConsideradoPartida = 0 // mínimo a puntuar para acumular una partida
    
    /**
     Obtención de los record para cada tipo de patrón.
     Los records se almacenan en local a través de la clase UserDefaults
     */
    class func getRecordTipoPatron(_ tipoPatron: TipoPatron) -> Int {
        var puntuacion: Int
        switch tipoPatron {
        case .Acorde:
            puntuacion = UserDefaults.standard.integer(forKey: idRecordAcordes)
        case .Arpegio:
            puntuacion = UserDefaults.standard.integer(forKey: idRecordArpegios)
        case .Escala:
            puntuacion = UserDefaults.standard.integer(forKey: idRecordEscalas)
        }
        return puntuacion
    }
    
    /**
     Almacenamiento de los records para cada tipo de patrón
     */
    class func setRecordTipoPatron(_ tipoPatron: TipoPatron, puntos: Int) {
        switch tipoPatron {
        case .Acorde:
            UserDefaults.standard.set(puntos, forKey: idRecordAcordes)
        case .Arpegio:
            UserDefaults.standard.set(puntos, forKey: idRecordArpegios)
        case .Escala:
            UserDefaults.standard.set(puntos, forKey: idRecordEscalas)
        }
        
    }
    
    /**
     Obtención de la puntuación acumulada
     */
    class func getPartidasAcumuladas() -> Int {
        return UserDefaults.standard.integer(forKey: idPartidasAcumuladas)
    }
    
    /**
     Almacenamiento de la puntuación acumulada
     */
    class func setPartidasAcumuladas(_ partidas: Int) {
        UserDefaults.standard.set(partidas, forKey: idPartidasAcumuladas)
    }
}
