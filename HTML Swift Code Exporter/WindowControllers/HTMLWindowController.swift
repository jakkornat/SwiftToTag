import Cocoa

class HTMLWindowController: NSWindowController {

    var code: String!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        print("Code from new window: \(code)")
        
        if let crtl = self.contentViewController as? ConvertedVIewController{
            crtl.code = self.code
        }
        
    }

}
