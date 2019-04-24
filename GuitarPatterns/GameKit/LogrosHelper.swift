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
  
  static let PuntosHardWorker = 1000.0
  static let HardWorkerGuitarPlayerId = "es.codigoswift.guitarpatterns.hardworker"
  static let AmateurGuitarPlayerId = "es.codigoswift.guitarpatterns.amateurguitarplayer"
  static let IntermediateGuitarPlayerId = "es.codigoswift.guitarpatterns.intermediateguitarplayer"
  static let ProffesionalGuitarPlayerId = "es.codigoswift.guitarpatterns.proffesionalguitarplayer"
  
  /**
   Función que crea el logro de hardworker y calcula el porcentaje de consecución del objetivo.
   Este logro se consigue cuando el usuario alcanza una cifra de puntos determinada por la constante PuntosHardWorker.
  */
  class func HardWorkerLogro(puntos: Int) -> GKAchievement {
      let percent = Double(puntos)/LogrosHelper.PuntosHardWorker * 100
      let hardworkerLogro = GKAchievement( identifier: LogrosHelper.HardWorkerGuitarPlayerId)
  
      hardworkerLogro.percentComplete = percent
      hardworkerLogro.showsCompletionBanner = true
      return hardworkerLogro
  }
  
  /**
   Función que crea los logros para cada tipo de ejercicio (acordes, arpegios, escalas)
   Este logro se consigue cuando el usuario alcanza una cifra de puntos determinada por la constante PuntosHardWorker.
   */
  class func logroParaTipoPatron(tipoPatron: TipoPatron) -> GKAchievement {
      var logroId: String
    
      switch tipoPatron {
      case .Acorde:
        logroId = LogrosHelper.AmateurGuitarPlayerId
      case .Arpegio:
        logroId = LogrosHelper.IntermediateGuitarPlayerId
      case .Escala:
        logroId = LogrosHelper.ProffesionalGuitarPlayerId
      }
      
      let logro = GKAchievement(identifier: logroId)
      logro.percentComplete = 100
      logro.showsCompletionBanner = true
      return logro
  }
  
}
