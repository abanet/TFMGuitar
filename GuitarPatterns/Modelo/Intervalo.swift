//
//  Intervalo.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 4/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation

/**
 Intervalos musicales representados con dos caracteres
 */
enum TipoIntervaloMusical: String, CaseIterable {
    case unisono            = "T"
    case segundamenor       = "2b"
    case segundamayor       = "2"
    case terceramenor       = "3b"
    case terceramayor       = "3"
    case cuartajusta        = "4"
    case cuartaaumentada    = "4+"
    case quintadisminuida   = "5-"
    case quintajusta        = "5"
    case sextamenor         = "6b"
    case sextamayor         = "6"
    case septimamenor       = "7b"
    case septimamayor       = "7"
    case octavajusta        = "8"
    
    
    static func tonica() -> TipoIntervaloMusical {
        return TipoIntervaloMusical.unisono
    }
    
    /**
     Devuelve la inversión de un intervalo musical
    */
    func inversion() -> TipoIntervaloMusical {
        switch self {
        case .unisono:
            return .unisono
        case .segundamenor:
            return .septimamayor
        case .segundamayor:
            return .septimamenor
        case .terceramenor:
            return .sextamayor
        case .terceramayor:
            return .sextamenor
        case .cuartajusta:
            return .quintajusta
        case .cuartaaumentada:
            return .quintadisminuida
        case .quintadisminuida:
            return .cuartaaumentada
        case .quintajusta:
            return .cuartajusta
        case .sextamenor:
            return .terceramayor
        case .sextamayor:
            return .terceramenor
        case .septimamenor:
            return .segundamayor
        case .septimamayor:
            return .segundamenor
        case .octavajusta:
            return .octavajusta
        }
    }
    
    /**
     Distancia en semitonos del intervalo
    */
    func distancia() -> Int {
        switch self {
        case .unisono:
            return 0
        case .segundamenor:
            return 1
        case .segundamayor:
            return 2
        case .terceramenor:
            return 3
        case .terceramayor:
            return 4
        case .cuartajusta:
            return 5
        case .cuartaaumentada:
            return 6
        case .quintadisminuida:
            return 6
        case .quintajusta:
            return 7
        case .sextamenor:
            return 8
        case .sextamayor:
            return 9
        case .septimamenor:
            return 10
        case .septimamayor:
            return 11
        case .octavajusta:
            return 12
        }
    }
    
    /**
     Intervalos con una distancia de semitonos dada
    */
    func intervalosConDistancia(semitonos: Int) -> [TipoIntervaloMusical] {
        var array = [TipoIntervaloMusical]()
        TipoIntervaloMusical.allCases.forEach {
            if $0.distancia() == semitonos {
                array.append($0)
            }
        }
        return array
    }
    
}


extension TipoIntervaloMusical: Hashable {
    static func == (lhs: TipoIntervaloMusical, rhs: TipoIntervaloMusical) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
