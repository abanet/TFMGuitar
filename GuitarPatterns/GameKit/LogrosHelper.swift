//
//  LogrosHelper.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 24/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import GameKit

class LogrosHelper {
  
    static let PartidasHardWorker = 5
    static let PuntosAmateur = 300
    static let PuntosIntermediate = 500
    static let PuntosProffesional = 1000
    static let HardWorkerGuitarPlayerId = "es.codigoswift.guitarpatterns.hardworker"
    static let AmateurGuitarPlayerId = "es.codigoswift.GuitarPatterns.amateurguitarplayer"
    static let IntermediateGuitarPlayerId = "es.codigoswift.GuitarPatterns.intermediateguitarplayer"
    static let ProffesionalGuitarPlayerId = "es.codigoswift.GuitarPatterns.proffesionalguitarplayer"
  
  /**
   Función que crea el logro de hardworker y calcula el porcentaje de consecución del objetivo.
   Este logro se consigue cuando el usuario alcanza una cifra de puntos determinada por la constante PuntosHardWorker.
  */
  class func HardWorkerLogro(partidas: Int) -> GKAchievement {
      let percent = Double(partidas/LogrosHelper.PartidasHardWorker * 100)
      let hardworkerLogro = GKAchievement( identifier: LogrosHelper.HardWorkerGuitarPlayerId)
  
      hardworkerLogro.percentComplete = percent
      hardworkerLogro.showsCompletionBanner = true
    
    // Este logro se puede obtener múltiples veces
    if partidas == PartidasHardWorker {
        Puntuacion.setPartidasAcumuladas(0)
    }
    return hardworkerLogro
  }
  
  /**
   Función que crea los logros para cada tipo de ejercicio (acordes, arpegios, escalas)
   */
    class func logroParaTipoPatron(tipoPatron: TipoPatron, puntos: Int) -> GKAchievement? {
        var logroId: String
        var logroSuperado: Bool = false
        
        switch tipoPatron {
        case .Acorde:
            logroId = LogrosHelper.AmateurGuitarPlayerId
            logroSuperado = puntos >= PuntosAmateur
        case .Arpegio:
            logroId = LogrosHelper.IntermediateGuitarPlayerId
            logroSuperado = puntos >= PuntosIntermediate
        case .Escala:
            logroId = LogrosHelper.ProffesionalGuitarPlayerId
            logroSuperado = puntos >= PuntosProffesional
        }
        
        if logroSuperado {
            let logro = GKAchievement(identifier: logroId)
            logro.percentComplete = 100
            logro.showsCompletionBanner = true
            return logro
        } else { return nil }
    }
    
  
}
