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
    
    var nombrePatron: String?
    var descripcionPatron: String?
    var categoriaPatron: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateForm()
    }
    
    /**
     Crea el formulario para obtener los datos del patrón
     */
    func populateForm() {
        form
            +++ Section("Introduzca los datos del patrón".localizada())
            <<< SegmentedRow<String>() {
                //$0.title = "Selecciona un tipo de patrón"
                $0.options = [TipoPatron.Acorde.rawValue,
                              TipoPatron.Arpegio.rawValue,
                              TipoPatron.Escala.rawValue]
                $0.displayValueFor = { tipopatron in
                    return tipopatron?.localizada()
                }
                $0.tag = "tipo_patron"
                if let categoriaPatron = categoriaPatron {
                    switch categoriaPatron {
                    case "Acorde":
                        $0.value = $0.options![0]
                    case "Arpegio":
                        $0.value = $0.options![1]
                    case "Escala":
                        $0.value = $0.options![2]
                    default:
                         $0.value = $0.options!.first
                    }
                } else {
                     $0.value = $0.options!.first
                }
               
                }.cellSetup() { cell, row in
                    cell.backgroundColor = Colores.background
                    cell.tintColor = .white
            }
            <<< TextRow(){ row in
                row.title = "Nombre del patrón".localizada()
                row.placeholder = "Introduce el nombre del patrón".localizada()
                row.value = nombrePatron
                row.tag = "nombre_patron"
                }.cellSetup() { cell, row in
                    cell.backgroundColor = Colores.background
                    cell.tintColor = .white
                }
            <<< TextRow(){ row in
                row.title = "Descripción del patrón".localizada()
                row.placeholder = "Introduce la descripción del patrón".localizada()
                row.tag = "descripcion_patron"
                row.value = descripcionPatron
                }.cellSetup() { cell, row in
                    cell.backgroundColor = Colores.background
                    cell.tintColor = .white
                }
            
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "Save".localizada()
                $0.onCellSelection(btnGrabarPulsado)
                }.cellSetup() { cell, row in
                    cell.backgroundColor = Colores.noteFillResaltada
                    cell.tintColor = .white
            }
            
            <<< ButtonRow(){
                $0.title = "Salir".localizada()
                $0.onCellSelection(btnSalirPulsado)
                }.cellSetup() { cell, row in
                    cell.backgroundColor = Colores.tonica
                    cell.tintColor = .white
        }
        self.tableView?.backgroundColor = Colores.background
    }
    
    
    func btnGrabarPulsado(cell: ButtonCellOf<String>, row: ButtonRow) {
        // Coger los datos del formulario
        let formValores = self.form.values()
        if let nombre = formValores["nombre_patron"]! as? String {
            // Todo correcto para grabar
            let categoria   = formValores["tipo_patron"]! as! String // siempre existe
            let descripcion = formValores["descripcion_patron"] as? String ?? ""
            delegate?.onFormularioRelleno(nombre: nombre, descripcion: descripcion, tipo: categoria)
            self.dismiss(animated: true, completion: nil)
        } else {
            Alertas.mostrar(titulo: "¡Datos incompletos!".localizada(), mensaje: "El patrón tiene que tener un nombre.".localizada(), enViewController: self)
        }
    }
    
    func btnSalirPulsado(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
