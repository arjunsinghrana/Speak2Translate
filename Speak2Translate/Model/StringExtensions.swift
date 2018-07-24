//
//  StringExtensions.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation

extension String {
    
    // This will remove all white spaces at the beginning and end of a string.
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // This function removes consecutive whitespaces and replaces them with a single whitespace
    func removeExtraWhiteSpaces() -> String {
        var newString = ""
        var isFirstSpace = true
        
        for character in self.trim() {
            
            if character != " " {
                newString.append(character)
                isFirstSpace = true
            } else {
                if isFirstSpace { newString.append(character) }
                isFirstSpace = false
            }
        }
        return newString
    }
    
    func removeCountryCode() -> String {
        let substrings = self.split(separator: "-")
        return String(substrings.first!)
    }
    
}
