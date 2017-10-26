import Foundation

class HTML{
    private var code: String
    
    init(code: String) {
        self.code = code
    }
    
    static private var _fileName: String = "swift_to_tag"
    
    func convertToHtml() -> String{
        var html = ""
        
        code.removeSpecialCharacters()
        
        //Add started tag
        html += "<pre><code>"
        
        // enumerate code lines
        
        self.code.enumerateLines(invoking: {(line, invoking) in
            var mutableLine = line
            
            //comments
            let commentRegexPattern = "\\/\\/(.*)"
            let commentRegex = try! NSRegularExpression(pattern: commentRegexPattern,
                                                        options: .caseInsensitive)
            
            let matchesComment = commentRegex.matches(in: mutableLine,
                                                      range: NSMakeRange(0, mutableLine.utf16.count))
            
            let comments = matchesComment.map { result -> String in
                let hrefRange = result.range(at: 1)
                let start = String.UTF16Index.init(encodedOffset: hrefRange.location - 2)
                let end = String.UTF16Index.init(encodedOffset: hrefRange.location + hrefRange.length)
                
                mutableLine.replaceSubrange(start..<end, with: "<span class=\"comment\">\(String(mutableLine.utf16[start..<end])!)</span>")
                
                return String(mutableLine.utf16[start..<end]) ?? ""
            }
            
            if (comments.count > 0){
                html += "\n\(mutableLine)"
                return
            }
            
            // Check keywords in text
            for word in mutableLine.words(){
                // Finding keywords
                if word.isKeyword(){
                    print(word)
                    
                    let keywordRegex = try! NSRegularExpression(pattern: "\\b\(word)\\b", options: .caseInsensitive)
                    keywordRegex.matches(in: mutableLine,
                                         range: NSMakeRange(0, mutableLine.utf16.count)).map{ result -> String? in
                                            let hrefRange = result.range(at: 0)
                                            let start = String.Index.init(encodedOffset: hrefRange.location)
                                            
                                            let tag = "<span class=\"keyword\">"
                                            
                                            let end = String.Index.init(encodedOffset: hrefRange.location + hrefRange.length + tag.count)
                                            
                                            mutableLine.insert(contentsOf: tag, at: start)
                                            mutableLine.insert(contentsOf: "</span>", at: end)
                                            
                                            return nil
                    }

                    
                }else if word.firstCapital(){
                    if let range = mutableLine.range(of: "\(word)"){
                        mutableLine.replaceSubrange(range, with: word.insertIn(tag: "span", options: ["class":"builtin"]))
                    }
                }
            }
            
            var characters = 0
            
            let methodRegex = try! NSRegularExpression(pattern: "\\.([a-zA-z0-9])+", options: .caseInsensitive)
            methodRegex.matches(in: mutableLine,
                                 range: NSMakeRange(0, mutableLine.utf16.count)).map{ result -> String? in
                                    
                                    print("LINE: \(mutableLine)")
                                    
                                    let hrefRange = result.range(at: 0)
                                    let start = String.Index.init(encodedOffset: hrefRange.location + characters + 1)
                                    
                                    let tag = "<span class=\"method\">"
                                    
                                    let end = String.Index.init(encodedOffset: hrefRange.location + hrefRange.length + tag.count + characters)
                                    
                                    mutableLine.insert(contentsOf: tag, at: start)
                                    mutableLine.insert(contentsOf: "</span>", at: end)
                                    
                                    print("Start: \(hrefRange.location)\nEnd: \(hrefRange.location + hrefRange.length + tag.count)")
                                    
                                    characters += tag.count + "</span>".count
                                    
                                    return nil
            }
            
            
            
            let stringRegexPattern = "(\"([^\"]|\"\")*\")"
            let stringRegex = try! NSRegularExpression(pattern: stringRegexPattern,
                                                       options: .caseInsensitive)
            
            let matchesString = stringRegex.matches(in: mutableLine,
                                                    range: NSMakeRange(0, mutableLine.utf16.count))

            characters = 0
            
            var _partOfNonMarkableString = false
            
            let strings = matchesString.map { result -> String in
                let hrefRange = result.range(at: 0)
                
                if _partOfNonMarkableString{ _partOfNonMarkableString = false }
                
                let letterBeforeIndex = String.UTF16Index.init(encodedOffset: hrefRange.location + characters - 1)
                let start = String.UTF16Index.init(encodedOffset: hrefRange.location + characters)
                
                let tag = "<span class=\"string-rep\">"
                
                let end = String.UTF16Index.init(encodedOffset: hrefRange.location + hrefRange.length + tag.count + characters)
                
                if mutableLine[letterBeforeIndex] == "="{
                    _partOfNonMarkableString = true
                    return ""
                }
                
                
                mutableLine.insert(contentsOf: tag, at: start)
                mutableLine.insert(contentsOf: "</span>", at: end)
                
                characters += tag.count + "</span>".count
                
                return "String(mutableLine.utf16[start..<end])!"
            }
            
            html += "\n\(mutableLine)"
        })
        
        //Add ending tag
        html += "\n</code></pre>"
        return html
    }
    
    static func filename() -> String{
        return UserDefaults.standard.string(forKey: "filename") ?? "tag_to_swift"
    }
    
    static func setFilename(name: String){
        UserDefaults.standard.set(name, forKey: "filename")
    }
    
    private func insertIn(tag: String, options: [String:String], text: String) -> String{
        var tagged = "<\(tag) "
        for option in options{
            tagged += "\(option.key)=\"\(option.value)\""
        }
        tagged += ">\(text)</\(tag)>"
        return tagged
    }
    
}
