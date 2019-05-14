//
//  Alertas.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/4/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit

/**
 Clase genérica para trabajar con las alertas al usuario.
 */

class Alertas {
    
    /**
     Alerta que muestra un mensaje informativo sin opciones.
     - Parameter titulo: título de la alerta,
     - Parameter mensaje: descripción de la alerta,
     - Parameter enViewController: ViewController que lanzará la alerta.
     */
    static func mostrar(titulo: String, mensaje: String, enViewController vc: UIViewController) {
        let alertController = UIAlertController(title: titulo, message:
            mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Alerta que muestra un mensaje informativo con opción de aceptar o cancelar.
     - Parameter titulo: título de la alerta,
     - Parameter mensaje: descripción de la alerta,
     - Parameter enViewController: ViewController que lanzará la alerta.
     - Parameter completion: closure a ejecutar en caso de que el usuario acepte.
     */
    static func mostrarOkCancel(titulo: String, mensaje: String, enViewController vc: UIViewController, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok".localizada(), style: .default, handler: completion))
        alertController.addAction(UIAlertAction(title: "Cancelar".localizada(), style: .cancel, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
}
