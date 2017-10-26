//
//  WebOutlookViewController.swift
//  HTML Swift Code Exporter
//
//  Created by Jakub Kornatowski  on 20.10.2017.
//  Copyright © 2017 Jakub Kornatowski . All rights reserved.
//

import Cocoa
import WebKit

class WebOutlookViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadHTMLString("<h1>Hello!, World!</h1>", baseURL: nil)
    }
}


