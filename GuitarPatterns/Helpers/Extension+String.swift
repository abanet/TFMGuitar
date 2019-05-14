//
//  Extension+String.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 04/04/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
import UIKit

/**
 Extendemos String para economizar esfuerzos a la hora de localizar el código
 */
extension String {
    func localizada() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
