//
//  TranslationModel.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation

typealias SearchComplete = (_ isSuccessful: Bool, _ response: String) -> Void
typealias RetrievedLanguageList = (_ isSuccessful: Bool, _ response: [Language]) -> Void
typealias SupportedLanguagesForTarget = (_ isSuccessful: Bool, _ response: [Language]) -> Void

struct SupportedTargetLanguageResponseModel: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let languages: [Language]
        
        struct Language: Decodable {
            let language: String
        }
    }
}

struct TranslationResponseModel: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let translations: [Translation]
        
        struct Translation: Decodable {
            let translatedText: String
        }
    }
}

struct SupportedLanguagesForTargetResponseModel: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let languages: [Language]
        
        struct Language: Decodable {
            let language: String
            let name: String
        }
    }
}

struct LanguagDetectionResponseModel {
    let data: Data
    
    struct Data {
        let detections: [Detection]
        
        struct Detection {
            let confidence: String
            let isReliable: String
            let language: String
        }
    }
}
