//
//  ConvertedVIewController.swift
//  HTML Swift Code Exporter
//
//  Created by Jakub Kornatowski  on 17.10.2017.
//  Copyright © 2017 Jakub Kornatowski . All rights reserved.
//

import Cocoa

class ConvertedVIewController: NSViewController, NSTextViewDelegate{

    var code: String!
    
    @IBOutlet weak var html: NSTextView!
    @IBOutlet var text: NSTextView!
    @IBOutlet var css: NSTextView!
    @IBOutlet weak var saveCSSButton: NSButton!
    @IBOutlet weak var toastLabel: NSTextField!
    @IBOutlet weak var toastLabelConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        css.delegate = self
        css.textContainerInset.width = 20
        
        if code != nil
        {
            text.textStorage?.mutableString.setString(code)
        }
        
        css.textStorage?.mutableString.setString(CSS.shared().getCSS())
    }
    @IBAction func copyToPasteboard(_ sender: Any) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.writeObjects([code as NSString])
        
        showToastLike(message: "😎\nHTML copied to clipboard")
        
    }
    
    func showToastLike(message: String){
        
        toastLabel.stringValue = message
        
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 0.5
            toastLabelConstraint.animator().constant = 0.0
        }, completionHandler:{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                
                NSAnimationContext.runAnimationGroup({ _ in
                    NSAnimationContext.current.duration = 0.5
                    self.toastLabelConstraint.animator().constant = 100.0
                }, completionHandler:{
                    self.toastLabelConstraint.constant = -100.0
                })
                
            })
        })
    }
    
    @IBAction func saveCss(_ sender: NSButton) {
        if let css = css.textStorage?.string{
            CSS.shared().setCSS(with: css)
            CSS.shared().saveCss()
        }
        sender.isEnabled = false
        
        showToastLike(message: "CSS saved\n💪")
        
    }
    
    func textDidChange(_ notification: Notification) {
        saveCSSButton.isEnabled = true
    }
    @IBAction func saveFile(_ sender: Any) {
        
        showToastLike(message: "Wait... saving file...")
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = HTML.filename()
        panel.isExtensionHidden = true
        panel.allowedFileTypes = ["html"]
        
        panel.beginSheetModal(for: self.view.window!, completionHandler: {result in
            do
            {
                try self.code.write(to: panel.url!, atomically: false, encoding: String.Encoding.utf8)
                
            }
            catch{}
        })
    }
}
