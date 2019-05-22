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

// Variables del tipo Patron en iCloud
enum iCloudPatron {
    static let nombre = "nombre"
    static let descripcion = "descripcion"
    static let tipo = "tipo"
    static let tonica = "tonica"
    static let trastes = "trastes"
    static let visible = "visible"
}

// Zonas definidas en iCloud
enum iCloudZones {
    static let favoritos = "Favoritos"
}

// Existirá un caché de patrones privada y otra pública
enum TipoCache {
    case privada
    case publica
}

/**
 PatronesDB se encarga de la gestión de la base de datos en iCloud.
 Mantiene, además, la lógica de las cachés.
 Utilizamos el patrón llamado Singleton para el acceso a la base de datos.
 */
class PatronesDB {
    
    static let share = PatronesDB() // instancia única de PatronesDB
    
    // contenedores y bases de datos
    var container: CKContainer!
    var publicDB : CKDatabase! // base de datos común
    var privateDB: CKDatabase! // base de datos privada de cada usuario
    var sharedDB : CKDatabase! // base de datos que utilizamos para compartir registros.
    var registroActual: CKRecord? // registro que se está tratando en cada momento
    
    var cachePatronesPublica: [Patron] = [Patron]()
    var cachePatronesPrivada: [Patron] = [Patron]()
    
    var patronesZone: CKRecordZone? // al trabajar en la base de datos privada no podemos trabajar con default. Es necesario crear una zona.
    
    private init() {
        //container = CKContainer.default()
        container = CKContainer(identifier: "iCloud.es.codigoswift.GuitarPatterns")
        //container = CKContainer.init(identifier: "iCloud.es.codigoswift.GuitarPatterns")
        publicDB  = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB  = container.sharedCloudDatabase
        
        // creación de la zona privada
        // Si no existe una zona privada la creamos. En otro caso la recuperamos para trabajar posteriormente con ella.
        let recordZone = CKRecordZone(zoneName: iCloudZones.favoritos)
        
        privateDB.fetch(withRecordZoneID: recordZone.zoneID) {
            retrievedZone, error in
            if error != nil {
                print(error!.localizedDescription)
                let ckError = error! as NSError
                if ckError.code == CKError.zoneNotFound.rawValue {
                    // Crear la zona privada
                    let operation = CKModifyRecordZonesOperation(recordZonesToSave: [recordZone], recordZoneIDsToDelete: nil)
                    operation.modifyRecordZonesCompletionBlock = { (savedRecordZones, deletedRecordZonse, error) in
                        if error != nil {
                            //Creation Failed
                            print("Cloud Error\n\(error?.localizedDescription)")
                        } else {
                            // Zone creation succeeded
                            self.patronesZone = savedRecordZones?.first
                        }
                    }
                    self.privateDB.add(operation)
// Primer intentdo de crear zona en privada que no ha funcionado en producción
//                    self.privateDB.save(recordZone) {
//                        newZone, error in
//                        if error != nil {
//                            print(error!.localizedDescription)
//                        } else {
//                            self.patronesZone = retrievedZone
//                        }
//                    }
                }
            } else {
                if let retrievedZone = retrievedZone {
                    self.patronesZone = retrievedZone
                }
            }
        }
    }
    
    /**
     Crea un registro nuevo en iCloud
     */
    func crearNuevoRegistro() {
        registroActual = CKRecord(recordType: iCloudRegistros.patron)
    }
    
    /**
     Crea un registro nuevo en la base de datos privada en iCloud
     */
    func crearNuevoRegistroPrivado() {
        guard let patronesZone = patronesZone else { return }
        let recordID = CKRecord.ID(zoneID: patronesZone.zoneID)
        registroActual = CKRecord(recordType: iCloudRegistros.patron, recordID: recordID)
        // Obsoleto:
        //registroActual = CKRecord(recordType: iCloudRegistros.patron, zoneID: patronesZone.zoneID)
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
     - Parameter patron: patron que vamos a grabar
     - Parameter completion: handler que se ejecutará tras la grabación.El parámetro de tipo Bool indicará si la grabación ha tenido éxito o no.
     */
    func grabarPatronEnPublica(_ patron: Patron, completion: @escaping (Bool) ->()) {
        grabarPatron(patron, enBbdd: publicDB, cache: .publica, completion: completion)
    }
    
    /**
     Graba un patrón en la base de datos privada
     - Parameter patron: patron que vamos a grabar
     - Parameter completion: handler que se ejecutará tras la grabación.El parámetro de tipo Bool indicará si la grabación ha tenido éxito o no.
     */
    func grabarPatronEnPrivada(_ patron: Patron, completion: @escaping (Bool) ->()) {
        grabarPatron(patron, enBbdd: privateDB, cache: .privada, completion: completion)
    }
    
    /**
     Crea y graba un patrón en la base de datos indicada.
     El patrón tiene que contener datos válidos
     - Parameter patron: patron que vamos a grabar
     - Parameter enBbdd: base de datos en la que vamos a grabar (pública, privada o share)
     - Parameter cache: tipo de la caché en la que vamos a mantener dicho patrón
     - Parameter completion: handler a ejetutar tras la grabación. El parámetro de tipo Bool indicará si la grabación ha tenido éxito o no.
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
        registro[iCloudPatron.descripcion] = patron.getDescripcion() as NSString
        
        if let tipo = patron.getTipo() {
            registro[iCloudPatron.tipo] = tipo.rawValue as NSString
        } else {
             registro[iCloudPatron.tipo] = TipoPatron.Acorde.rawValue // acorde por defecto
        }
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
    
    /**
     Obtiene todos los patrones de la base de datos pública.
     - Parameter completion: función que recibe como parámetros un array con los patrones leídos.
     */
    func getPatronesPublica(completion: @escaping ([Patron]) ->()) {
        if cachePatronesPublica.count == 0 {
            getPatrones(bbdd: publicDB, privada: false, completion: completion)
        } else {
            completion(cachePatronesPublica)
        }
    }
    
    /**
     Obtiene todos los patrones de la base de datos privada.
     - Parameter completion: función que recibe como parámetros un array con los patrones leídos.
     */
    func getPatronesPrivada(completion: @escaping ([Patron]) ->()) {
        if cachePatronesPrivada.count == 0 {
            getPatrones(bbdd: privateDB, privada: true, completion: completion)
        } else {
            completion(cachePatronesPrivada)
        }
    }
    
    /**
     Elimina todos los patrones de la base de datos privada
     */
    func setPatronesPrivadaToNil() {
        self.cachePatronesPrivada.removeAll()
    }
    
    /**
     Función genérica para la lectura de patrones de la base de datos en iCloud
     - Parameter bbdd: Base de datos de la que vamos a leer
     - Parameter privada: indica si es privada o no. Es necesario saberlo ya que si se va a leer de la privada hay que leerlos de la zona creada en la base de datos del usuario. En caso contrario se leerá de default.
     - Parameter completion: función a ejecutar una vez leídos los patrons. Esta función recibe como parámetro un array con todos los patrones leídos.
     */
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
    
    /**
     Elimina un registro dado de la base de datos indicada
     */
    func eliminarRegistro(id: CKRecord.ID, bbdd: CKDatabase) {
        bbdd.delete(withRecordID: id) { (id: CKRecord.ID?, error: Error?) -> Void in
            if error == nil {
                print("Registro eliminado", id ?? "nil")
                
            }
        }
    }
    
    /**
     Elimina un registro de la base de datos pública.
     La eliminación de la base de datos supone la eliminación de la caché de datos asociada.
     - Parameter id: identificador del registro a eliminar.
     */
    func eliminarRegistroPublica(id: CKRecord.ID) {
        eliminarRegistro(id: id, bbdd: publicDB)
        for (indice, patron) in self.cachePatronesPublica.enumerated() {
            if patron.getId() == id {
                self.cachePatronesPublica.remove(at: indice)
                break
            }
        }
    }
    
    /**
     Elimina un registro de la base de datos privada.
     La eliminación de la base de datos supone la eliminación de la caché de datos asociada.
     - Parameter id: identificador del registro a eliminar.
     */
    func eliminarRegistroPrivada(id: CKRecord.ID) {
        eliminarRegistro(id: id, bbdd: privateDB)
        for (indice, patron) in self.cachePatronesPrivada.enumerated() {
            if patron.getId() == id {
                self.cachePatronesPrivada.remove(at: indice)
                break
            }
        }
    }
    
    /**
     Elimina un registro únicamente de la caché privada
     - Parameter indice: posición del array a eliminar
     */
    func eliminarRegistroCachePrivada(indice: Int) {
        self.cachePatronesPrivada.remove(at: indice)
    }
    
}
