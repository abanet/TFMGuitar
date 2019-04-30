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

enum iCloudZones {
    static let favoritos = "Favoritos"
}

enum TipoCache {
    case privada
    case publica
}

class PatronesDB {
    
    static let share = PatronesDB()
    
    var container: CKContainer!
    var publicDB : CKDatabase!
    var privateDB: CKDatabase!
    var sharedDB : CKDatabase!
    var registroActual: CKRecord?
    
    var cachePatronesPublica: [Patron] = [Patron]()
    var cachePatronesPrivada: [Patron] = [Patron]()
    
    var patronesZone: CKRecordZone?
    
    private init() {
        container = CKContainer.default()
        publicDB  = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB  = container.sharedCloudDatabase
        
        // creación de la zona privada
        let recordZone = CKRecordZone(zoneName: iCloudZones.favoritos)
        privateDB.fetch(withRecordZoneID: recordZone.zoneID) {
            retrievedZone, error in
            if error != nil {
                print(error!.localizedDescription)
                let ckError = error! as NSError
                if ckError.code == CKError.zoneNotFound.rawValue {
                    self.privateDB.save(recordZone) {
                        newZone, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            self.patronesZone = retrievedZone
                        }
                    }
                }
            } else {
                if let retrievedZone = retrievedZone {
                    self.patronesZone = retrievedZone
                }
            }
        }
    }
 
    /**
     Crea un registro nuevo
     */
    func crearNuevoRegistro() {
        registroActual = CKRecord(recordType: iCloudRegistros.patron)
    }
    
    func crearNuevoRegistroPrivado() {
        guard let patronesZone = patronesZone else { return }
        registroActual = CKRecord(recordType: iCloudRegistros.patron, zoneID: patronesZone.zoneID)
    }
    
    /**
     Cierra el registro sobre el que se está trabajando en la base de datos
    */
    func cerrarRegistro() {
        registroActual = nil
    }

    // MARK: Funciones de grabación en la base de datos
    /**
     Graba un patrón en la base de datos pública
    */
    func grabarPatronEnPublica(_ patron: Patron, completion: @escaping (Bool) ->()) {
        grabarPatron(patron, enBbdd: publicDB, cache: .publica, completion: completion)
    }
    
    /**
     Graba un patrón en la base de datos privada
     */
    func grabarPatronEnPrivada(_ patron: Patron, completion: @escaping (Bool) ->()) {
        grabarPatron(patron, enBbdd: privateDB, cache: .privada, completion: completion)
    }
    
    /**
     Crea y graba un patrón en la base de datos indicada.
     El patrón tiene que contener datos válidos
    */
    func grabarPatron(_ patron: Patron, enBbdd bbdd: CKDatabase, cache: TipoCache, completion: @escaping (Bool) ->()) {
        // creamos registro con los datos del patrón
      if let registro = patron.getRegistro() {
        registroActual = registro
      }
      
        if registroActual == nil  { // creamos un registro nuevo
            
            switch cache {
            case .privada:
                crearNuevoRegistroPrivado() // crea un registro en la zona privada
                cachePatronesPrivada.append(patron)
            case .publica:
                crearNuevoRegistro() // crea un registro en la zona pública
                cachePatronesPublica.append(patron)
            }
            
        } else {
            for (indice, patron) in cachePatronesPublica.enumerated() {
                if patron.getId() == registroActual?.recordID {
                    switch cache {
                    case .privada:
                        cachePatronesPrivada[indice] = patron
                    case .publica:
                        cachePatronesPublica[indice] = patron
                    }
                    break
                }
            }
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
    
    // MARK: Funciones de recuperación de registros en la base de datos
    func getPatronesPublica(completion: @escaping ([Patron]) ->()) {
        if cachePatronesPublica.count == 0 {
          getPatrones(bbdd: publicDB, privada: false, completion: completion)
        } else {
            completion(cachePatronesPublica)
        }
    }
    
    func getPatronesPrivada(completion: @escaping ([Patron]) ->()) {
        if cachePatronesPrivada.count == 0 {
          getPatrones(bbdd: privateDB, privada: true, completion: completion)
        } else {
            completion(cachePatronesPrivada)
        }
    }
  
  func setPatronesPrivadaToNil() {
    self.cachePatronesPrivada.removeAll()
  }
    
  func getPatrones(bbdd: CKDatabase, privada: Bool, completion: @escaping ([Patron]) ->()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: iCloudRegistros.patron, predicate: predicate)
    
        var zonaID: CKRecordZone.ID? = nil
        if privada { //Si estamos en la privada se cogerán de la zona de favoritos.
            zonaID = patronesZone?.zoneID
        }
    
        bbdd.perform(query, inZoneWith: zonaID) { registros, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                guard let registros = registros else { return }
                var patrones = [Patron]()
                for registro in registros {
                    if let patron = Patron(iCloudRegistro: registro) {
                        patrones.append(patron)
                      if privada {
                        self.cachePatronesPrivada.append(patron)
                      } else {
                        self.cachePatronesPublica.append(patron)
                      }
                    }
                }
                completion(patrones)
            }
            
        }
    }
    
    func eliminarRegistro(id: CKRecord.ID, bbdd: CKDatabase) {
        bbdd.delete(withRecordID: id) { (id: CKRecord.ID?, error: Error?) -> Void in
            if error == nil {
                print("Registro eliminado", id ?? "nil")
                
            }
        }
    }
    
    func eliminarRegistroPublica(id: CKRecord.ID) {
        eliminarRegistro(id: id, bbdd: publicDB)
        for (indice, patron) in self.cachePatronesPublica.enumerated() {
            if patron.getId() == id {
                self.cachePatronesPublica.remove(at: indice)
                break
            }
        }
    }
    
    func eliminarRegistroPrivada(id: CKRecord.ID) {
        eliminarRegistro(id: id, bbdd: privateDB)
        for (indice, patron) in self.cachePatronesPrivada.enumerated() {
            if patron.getId() == id {
                self.cachePatronesPrivada.remove(at: indice)
                break
            }
        }
    }

}
