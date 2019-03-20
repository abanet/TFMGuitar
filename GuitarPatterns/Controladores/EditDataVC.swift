//
//  EditDataVC.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit
import Eureka

class EditDataVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateForm()
    }
    
    func populateForm() {
        form
            +++ Section("Introduzca los datos del patrón")
            <<< SegmentedRow<String>() {
                //$0.title = "Selecciona un tipo de patrón"
                $0.options = ["Acordes", "Arpegios", "Escalas"]
                $0.tag = "tipo_patron"
                $0.value = $0.options?.last
            }
            <<< TextRow(){ row in
                row.title = "Nombre del patrón"
                row.placeholder = "Introduce el nombre del patrón"
                row.tag = "nombre_patron"
            }
            <<< TextRow(){ row in
                row.title = "Descripción del patrón"
                row.placeholder = "Introduce la descripción del patrón"
                row.tag = "descripcion_patron"
            }
            
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "Grabar"
                $0.onCellSelection(buttonTapped)
            }
        self.tableView?.backgroundColor = .purple
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        // Grabar datos y salir
        self.dismiss(animated: true, completion: nil)
    }
}
