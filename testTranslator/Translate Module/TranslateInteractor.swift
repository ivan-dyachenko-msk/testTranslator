//
//  TranslateInteractor.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol TranslateInteractorProtocolInput: ApiWrapperProtocolOutput {
    func translate(text: String)
    func getLanguagesForRequest(from: TranslateLanguages?, to: TranslateLanguages?) -> String
    func getLangFrom() -> Int
    func getLangTo() -> Int
    func setLangFrom(from: String)
    func setLangTo(to: String)
    func getArrayForPicker(row: Int) -> String
    func getCountForPicker() -> Int
    func reverseLang()
    func saveTranslate(_ text: String, translation: String)
}

protocol TranslateInteractorProtocolOutput: class {
    func translatedForPresenter(text: String)
}

class TranslateInteractor: TranslateInteractorProtocolInput {

    var wrapper: ApiWrapperProtocolInput!
    var presenter: TranslatePresenterProtocolInput!
    
    private var langFrom: TranslateLanguages {
        return UserSettings.getLanguageFrom()
    }
    
    private var langTo: TranslateLanguages {
        return UserSettings.getLanguageTo()
    }
    
    func getLangFrom() -> Int {
        
        return TranslateLanguages.getIndex(lang: self.langFrom.rawValue)
    }
    
    func getLangTo() -> Int {
        
        return TranslateLanguages.getIndex(lang: self.langTo.rawValue)
    }
    
    func setLangFrom(from: String) {
        
        UserSettings.setNewLanguageFrom(lang: from)
    }
    
    func setLangTo(to: String) {
        
        UserSettings.setNewLanguageTo(lang: to)
    }
    
    func translate(text: String) {
        
        self.wrapper.translateText(text: text, lang: getLanguagesForRequest(from: langFrom, to: langTo))
    }
    
    func translatedTextFromApiWrapper(text: DecodableResultText) {
        
        let t = text
        guard let result = t.text.first else { return }
        self.presenter.translatedForPresenter(text: result)
    }
    
    func getLanguagesForRequest(from: TranslateLanguages?, to: TranslateLanguages?) -> String {
        
        guard let from = from else {
            return "\(langFrom)"
        }
        guard let to = to else {
            return "-\(langTo)"
        }
        
        return TranslateLanguages.langOutput(from: from, to: to)
    }
    
    func getArrayForPicker(row: Int) -> String {
        
        return TranslateLanguages.getLanguagesPicker(row: row)
    }
    
    func getCountForPicker() -> Int {
        
        return TranslateLanguages.allCases.count
    }
    
    func reverseLang() {
        
        let oldFrom = langFrom
        let oldTo = langTo
        UserSettings.setNewLanguageFrom(lang: oldTo.rawValue)
        UserSettings.setNewLanguageTo(lang: oldFrom.rawValue)
    }
    
    func saveTranslate(_ text: String, translation: String) {
        
        let order = TranslateLanguages.getDataForSaveWord(langFrom: self.langFrom, langTo: self.langTo)
        
        if order.0 == "ru" {
            CoreDataManager.sharedInstance.saveWordInDataBase(text: text.lowercased(), trans: translation.lowercased(), language: order.1)
        }
        else
        {
            CoreDataManager.sharedInstance.saveWordInDataBase(text: translation.lowercased(), trans: text.lowercased(), language: order.0)
        }
    }
}
