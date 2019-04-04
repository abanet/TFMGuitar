//
//  EditDataVC.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import UIKit
import Eureka

protocol FormularioDelegate {
    func onFormularioRelleno (nombre: String, descripcion: String, tipo: String)
}
        
class EditDataVC: FormViewController {
    
    var delegate: FormularioDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateForm()
    }
    
    /**
     Crea el formulario para obtener los datos del patrón
     */
    func populateForm() {
        form
            +++ Section("Introduzca los datos del patrón")
            <<< SegmentedRow<String>() {
                //$0.title = "Selecciona un tipo de patrón"
                $0.options = ["Acordes", "Arpegios", "Escalas"]
                $0.tag = "tipo_patron"
                $0.value = $0.options!.last
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
        // Coger los datos del formulario
        let formValores = self.form.values()
        if let nombre = formValores["nombre_patron"]! as? String {
            // Todo correcto para grabar
            let categoria   = formValores["tipo_patron"]! as! String // siempre existe
            let descripcion = formValores["descripcion_patron"] as? String ?? ""
            delegate?.onFormularioRelleno(nombre: nombre, descripcion: descripcion, tipo: categoria)
            self.dismiss(animated: true, completion: nil)
        } else {
            Alertas.mostrar(titulo: "¡Datos incompletos!", mensaje: "El patrón tiene que tener un nombre.", enViewController: self)
        }
    }
    
    
}
