//
//  UserSettings.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 23/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

struct UserSettings
{
    static let defaults = UserDefaults.standard
    static let translateLanguageFrom = "translateLanguageFrom"
    static let translateLanguageTo = "translateLanguageTo"
    
    static func getLanguageFrom() -> TranslateLanguages {
        if let value = defaults.object(forKey: translateLanguageFrom) as? String {
            for lang in TranslateLanguages.allCases
            {
                if lang.rawValue == value
                {
                    return lang
                }
            }
        }
        return TranslateLanguages.ru
    }
    
    static func getLanguageTo() -> TranslateLanguages {
        if let value = defaults.object(forKey: translateLanguageTo) as? String {
            for lang in TranslateLanguages.allCases
            {
                if lang.rawValue == value
                {
                    return lang
                }
            }
        }
        return TranslateLanguages.en
    }
    
    static func setNewLanguageFrom(lang: String) {
        defaults.set(lang, forKey: translateLanguageFrom)
    }
    static func  setNewLanguageTo(lang: String) {
        defaults.set(lang, forKey: translateLanguageTo)
    }
}
