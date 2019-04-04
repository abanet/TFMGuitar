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
    
    static func mostrar(titulo: String, mensaje: String, enViewController vc: UIViewController) {
        let alertController = UIAlertController(title: titulo, message:
            mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alertController, animated: true, completion: nil)
    }
}
