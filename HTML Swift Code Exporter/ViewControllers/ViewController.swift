//
//  ViewController.swift
//  HTML Swift Code Exporter
//
//  Created by Jakub Kornatowski  on 21.09.2017.
//  Copyright © 2017 Jakub Kornatowski . All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var codeView: NSTextView!
    var code = ""
    let keywords = [ "let", "var", "import", "class", "override", "didSet" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeView.delegate = self
        CSS.shared().readCss()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func toHTML() -> String{
        code = (codeView.textStorage?.string) ?? ""
        
        let html = HTML(code: code)
        
        return html.convertToHtml()
    }

    @IBAction func exportToHTML(_ sender: Any) {
        
        //Open new window
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "showHTML"{
            if let destination = segue.destinationController as? ConvertedVIewController{
                destination.code = toHTML()
            }
        }
    }
    
    @IBAction func clearCode(_ sender: Any) {
        codeView.textStorage?.mutableString.setString("")
    }
}

