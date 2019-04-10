//
//  Boton.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 10/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit

/**
  Procedimientos usados en la creación de botones
 */
class Boton {
    static func crearBoton(nombre: String) -> UIButton {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.backgroundColor = Colores.botones
        b.setTitle(nombre, for: UIControl.State.normal)
        b.layer.cornerRadius = 5
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }
}
