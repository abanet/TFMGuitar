//
//  PatronesDB.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 5/4/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//
//  Clase de acceso a los contenedores y bases de datos en CloudKit

import Foundation
import CloudKit

// Custom Types
enum iCloudRegistros {
    static let patron = "Patron"
}

enum iCloudPatron {
    static let nombre = "nombre"
    static let descripcion = "descripcion"
    static let tipo = "tipo"
    static let tonica = "tonica"
    static let trastes = "trastes"
    static let visible = "visible"
}


class PatronesDB {
    
    static let share = PatronesDB()
    
    var container: CKContainer!
    var publicDB : CKDatabase!
    var privateDB: CKDatabase!
    var sharedDB : CKDatabase!
    var registroActual: CKRecord?
    
    private init() {
        container = CKContainer.default()
        publicDB  = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB  = container.sharedCloudDatabase
    }
 
    /**
     Crea un registro nuevo
     */
    func crearNuevoRegistro()-> CKRecord {
        let registro = CKRecord(recordType: iCloudRegistros.patron)
        return registro
    }
    
    /**
     Graba un patrón en la base de datos pública
    */
    func grabarPatronEnPublica(_ patron: Patron, completion: @escaping (Bool) ->()) {
        grabarPatron(patron, enBbdd: publicDB, completion: completion)
    }
    
    /**
     Crea y graba un patrón en la base de datos indicada.
     El patrón tiene que contener datos válidos
    */
    func grabarPatron(_ patron: Patron, enBbdd bbdd: CKDatabase, completion: @escaping (Bool) ->()) {
        // creamos registro con los datos del patrón
        if registroActual == nil { // creamos un registro nuevo
            registroActual = crearNuevoRegistro()
        }
        
        // a estas alturas tiene que haber un registro para modificar seguro pero por si acaso...
        guard let registro = registroActual else {
            return
        }
        
        registro[iCloudPatron.nombre] = patron.getNombre()! as NSString
        registro[iCloudPatron.descripcion] = patron.getDescripcion()! as NSString
        registro[iCloudPatron.tipo] = patron.getTipo()!.rawValue as NSString
        registro[iCloudPatron.tonica] = patron.codificarTonica() as Int
        registro[iCloudPatron.trastes] = patron.codificarTrastes() as [Int]
        registro[iCloudPatron.visible] = 1
        
        // grabar registro en base de datos
        bbdd.save(registro) { [unowned self] record, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(false)
            } else {
                completion(true)
                self.registroActual = record
            }
        }
    }
}
