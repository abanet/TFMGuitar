//
//  AppDelegate.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 1/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0) // Tiempo para disfrutar de la LaunchScreen
        
        return true
    }

    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
        // recibimos los datos compartidos
        let acceptOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptOperation.qualityOfService = .userInteractive
        acceptOperation.perShareCompletionBlock = {
            metadata, share, error in
            if error != nil {
                print(error?.localizedDescription ?? "No hay error definido en perShare")
            } else {
                print("Compartición aceptada")
            }
        }
        acceptOperation.acceptSharesCompletionBlock = { error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No hay error definido en acceptShares")
                return
            }
            
            let op = CKFetchRecordsOperation(recordIDs: [cloudKitShareMetadata.rootRecordID])
            op.perRecordCompletionBlock = { record, _, error in
                guard error == nil, record != nil else {
                    print(error?.localizedDescription ?? "No hay error definido en perRecord")
                    return
                }
                // hemos recibido un patrón. Vamos a grabarlo en la base de datos privada del receptor.
                // Hay crear un patron nuevo
                if let patron = Patron(iCloudRegistro: record!) {
                    patron.setRegistro(nil)
                    PatronesDB.share.cerrarRegistro()
                    PatronesDB.share.grabarPatronEnPrivada(patron) {grabado in
                        if grabado {
                        PatronesDB.share.setPatronesPrivadaToNil() // para obligar a recargar
                        DispatchQueue.main.async {
                            Alertas.mostrar(titulo: "¡Patron recibido!".localizada(), mensaje: "El patrón recibido se ha añadido a tu lista de patrones favoritos.".localizada(), enViewController: self.window!.rootViewController!)
                        }
                        }
                    }
                }
            
            }
            CKContainer.default().sharedCloudDatabase.add(op)
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptOperation )
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

