//
//  String+regexOperations.swift
//  HTML Swift Code Exporter
//
//  Created by Jakub Kornatowski  on 26.10.2017.
//  Copyright © 2017 Jakub Kornatowski . All rights reserved.
//

import Foundation


extension String {
    
    func words() -> [String] {
        let symbols = [ "-", "\\", "?", "{", "}", "(", ")", "=", "!", ">", "<", ":" ]
        var newString = self
        
        for symbol in symbols{
            newString = newString.replacingOccurrences(of: symbol, with: " ")
        }
        
        let words = newString.components(separatedBy: " ")
        
        return words
    }
    
    func firstCapital() -> Bool{
        let symbols = [ "-", "/", "\\", "?", "{", "}", "(", ")", "=", "\"", "!", ">", "<", "+", "[", "]", "." ]
        
        if !self.isEmpty{
            let firstLetter = String(self[startIndex])
            let firstCapitalized = String(self[startIndex]).capitalized
            
            if firstLetter.elementsEqual(firstCapitalized) && !symbols.contains(firstLetter) {
                return true
            }
        }
        return false
    }
    
    func isKeyword() -> Bool{
        let keyords = ["override", "subscript", "mutating", "in", "func", "super", "let", "if", "var", "return", "false", "true", "self", "struct", "func", "!self", "import", "init", "for", "private", "public", "static", "didSet", "else", "extension"]
        if keyords.contains(self){
            return true
        }
        return false
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    subscript (r: CountableClosedRange<Int>) -> String? {
        return String(self[startIndex...endIndex])
    }
    
    func insertIn(tag: String, options: [String:String]) -> String{
        var tagged = "<\(tag) "
        for option in options{
            tagged += "\(option.key)=\"\(option.value)\""
        }
        tagged += ">\(self)</\(tag)>"
        return tagged
    }
    
    mutating func removeSpecialCharacters(){
        self = self.replacingOccurrences(of: "<", with: "openTag")
        self = self.replacingOccurrences(of: ">", with: "closedTag")
    }
}
