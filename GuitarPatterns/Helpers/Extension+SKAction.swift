//
//  Extension+SKAction.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

/**
 Extendemos SKAction para simplificar la llamada a las secuencias de acción que realizamos con más frecuencia.
 */
public extension SKAction {
  /**
   * Realiza la acción después de un intervalo de tiempo determinado.
   */
  class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
    return SKAction.sequence([SKAction.wait(forDuration: delay), action])
  }
  
  /**
   * Ejecuta un bloque después de un intervalo de tiempo determinado.
   */
  class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
    return SKAction.afterDelay(delay, performAction: SKAction.run(block))
  }
  
  /**
   * Elimina el nodo de su padre después de un intervalo de tiempo determinado.
   */
  class func removeFromParentAfterDelay(_ delay: TimeInterval) -> SKAction {
    return SKAction.afterDelay(delay, performAction: SKAction.removeFromParent())
  }
  
  
}
