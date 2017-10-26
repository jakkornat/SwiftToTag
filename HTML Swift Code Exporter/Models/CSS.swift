import Foundation


class CSS{
    private static var instance: CSS?
    private var cssCode: String!
    
    init(cssCode: String) {
        self.cssCode = cssCode
    }
    
    static func shared() -> CSS{
        if instance == nil{
            let css = """
        .comment{
        color: green;
        }
        
        .keyword{
        color: orange;
        }
        
        .builtin{
        color: rgb(0, 174, 255);
        }
        
        .string-rep{
        color: red;
        }
        
        .method{
        color:  hotpink;
        }
        .line{
        color: lightslategray;
        }
        
        code{
        background-color: black;
        color: white;
        display: inline-block;
        margin: 10px;
        padding: 10px;
        border-radius: 10px;
        }
        """
        
            instance = CSS(cssCode: css)
        }
        
        return instance!
    }
    
    func getCSS() -> String{
        return cssCode
    }
    
    func setCSS(with: String){
        cssCode = with
    }
    
    func saveCss(){
        let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        //add the file
        let fileUrl = docUrl.appendingPathComponent("style.txt")
        
        do {
            try cssCode.write(to: fileUrl!, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            
        }
        
    }
    
    func readCss(){
        let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        
        let filePath = url.appendingPathComponent("style.txt").path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                cssCode = try String(contentsOf: docUrl.appendingPathComponent("style.txt")!, encoding: .utf8)
            } catch {}
        } else {
            return
        }
        
        
    }
    
}
