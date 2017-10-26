//
//  PreferencesViewController.swift
//  HTML Swift Code Exporter
//
//  Created by Jakub Kornatowski  on 26.10.2017.
//  Copyright © 2017 Jakub Kornatowski . All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var htmlFileNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        htmlFileNameTextField.stringValue = HTML.filename()
    }
    
    @IBAction func savePreferences(_ sender: Any) {
        if htmlFileNameTextField.stringValue != ""{
            HTML.setFilename(name: htmlFileNameTextField.stringValue)
        }
        self.view.window?.close()
    }
    
}
