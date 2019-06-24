//
//  TranslateLanguages.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 23/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

enum TranslateLanguages: String {
        
        case ru = "русский"
        case en = "английский"
        case es = "испанский"
        case fr = "французский"
        case it = "итальянский"
        case de = "немецкий"
}

extension TranslateLanguages: CaseIterable {
    
    static func langOutput(from: TranslateLanguages, to: TranslateLanguages) -> String {
        
        var outLang: String
       
        switch from {
        case .ru: outLang = "ru"
        case .en: outLang = "en"
        case .es: outLang = "es"
        case .fr: outLang = "fr"
        case .it: outLang = "it"
        case .de: outLang = "de"
        }
        
        switch to {
        case .ru: outLang += "-ru"
        case .en: outLang += "-en"
        case .es: outLang += "-es"
        case .fr: outLang += "-fr"
        case .it: outLang += "-it"
        case .de: outLang += "-de"
        }
        
        return outLang
    }
    
    static func getLanguagesPicker(row: Int) -> String {

        var l = TranslateLanguages.allCases
        return l[row].rawValue
    }
    
    static func getIndex(lang: String) -> Int {
        var int: Int = 0
        
        for i in TranslateLanguages.allCases.enumerated() {
            if i.element.rawValue == lang {
                print("INT OFFSET: \(i.offset)")
                int = i.offset
            }
        }
        return int
    }
    
    static func getDataForSaveWord(langFrom: TranslateLanguages, langTo: TranslateLanguages) -> (String,String) {
        let langs = langOutput(from: langFrom, to: langTo).components(separatedBy: "-")
        return (langs.first!, langs.last!)
    }
}
