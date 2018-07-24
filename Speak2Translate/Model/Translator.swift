//
//  Translator.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation
import Alamofire

class Translator {
    
    static func requestTranslation(source: String, target: String, textToTranslate: String, completion: @escaping SearchComplete) {
        
        // Add URL parameters
        let parameters = [
            "q": textToTranslate,
            "source": source,
            "target": target,
            "format": "text",
            "key" : Secrets.GoogleTranslationAPIKey
        ]
        
        // URL
        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2") else {
            completion(false, "")
            return
        }
        
        // Fetch Request
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: {(response) in
                
                if response.response?.statusCode != 200 {
                    print("Error receiving JSON for translated text")
                    completion(false, "")
                    return
                }
                
                var translatedText: String = ""
                
                do {
                    let decoder = JSONDecoder()
                    let parsedJSON: TranslationResponseModel = try decoder.decode(TranslationResponseModel.self, from: response.data!)
                    
                    let translations = parsedJSON.data.translations
                    
                    let translation = translations[0]
                    
                    translatedText = translation.translatedText
                }   catch {
                    print(error)
                }
                
                completion(true, translatedText)
                
            })
    }
    
    
    static func requestSupportedLanguages(completion: @escaping RetrievedLanguageList) {
        
        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2/languages") else {
            completion(false, [])
            return
        }
        
        let parameters = [
            "key" : Secrets.GoogleTranslationAPIKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                
                if response.response?.statusCode != 200 {
                    print("Error in retrieving JSON for supported languages")
                    return
                }
                
                var supportedLanguages: [Language] = []
                
                do {
                    let decoder = JSONDecoder()
                    let parsedJson: SupportedTargetLanguageResponseModel = try decoder.decode(SupportedTargetLanguageResponseModel.self, from: response.data!)
                    
                    let languages = parsedJson.data.languages
                    
                    for language in languages {
                        
                        let identifier: String = language.language
                        
                        let locale: Locale = Locale(identifier: identifier)
                        let string: String = locale.localizedString(forIdentifier: identifier)!
                        
                        let supportedLanguage: Language = Language(identifier: identifier, name: string)
                        
                        supportedLanguages.append(supportedLanguage)
                    }
                    
                }   catch {
                    print(error)
                }
                
                completion(true, supportedLanguages)
                
            })
    }
    
    
    static func requestSupportedLanguages(forTarget target: String, completion: @escaping SupportedLanguagesForTarget) {
        
        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2/languages") else {
            completion(false, [])
            return
        }
        
        let parameters = [
            "target" : target,
            "key" : Secrets.GoogleTranslationAPIKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                
                if response.response?.statusCode != 200 {
                    print("Error in retreiving JSON for supported languages for tareget language")
                    completion(false, [])
                    return
                }
                
                var supportedLanguages: [Language] = []
                
                do {
                    let decoder = JSONDecoder()
                    let parsedJSON: SupportedLanguagesForTargetResponseModel = try decoder.decode(SupportedLanguagesForTargetResponseModel.self, from: response.data!)
                    
                    let languages = parsedJSON.data.languages
                    
                    for language in languages {
                        
                        let identifier = language.language
                        let string = language.name
                        
                        let supportedLanguage = Language(identifier: identifier, name: string)
                        
                        supportedLanguages.append(supportedLanguage)
                    }
                    
                }   catch {
                    print("error")
                }
                
                supportedLanguages = supportedLanguages.sorted()
                
                completion(true, supportedLanguages)
                
            })
    }
    
}
