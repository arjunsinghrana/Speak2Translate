//
//  Language.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation

struct Language: Comparable, Equatable {
    
    var identifier: String
    var name: String
    
    //MARK: - Compare languages based on identifiers
    
    static func < (lhs: Language, rhs: Language) -> Bool {
        if lhs.name <= rhs.name {
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        if lhs.name == rhs.name {
            return true
        }
        return false
    }
    
}
