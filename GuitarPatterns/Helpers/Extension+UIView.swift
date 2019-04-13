//
//  Extension+UIView.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 13/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
import UIKit

extension UIView {
    /**
     La transición entre escenas no elimina los elementos de UIKit.
     Es necesario elimnarlos de forma explícita al cambiar de escena.
     */
    func eliminarUIKit() {
        for vista in self.subviews {
            vista.removeFromSuperview()
        }
    }
}
