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

class PatronesDB {
    
    static let share = PatronesDB()
    
    var container: CKContainer!
    var publicDB : CKDatabase!
    var privateDB: CKDatabase!
    var sharedDB : CKDatabase!
    
    private init() {
        container = CKContainer.default()
        publicDB  = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB  = container.sharedCloudDatabase
    }
    
    
}
