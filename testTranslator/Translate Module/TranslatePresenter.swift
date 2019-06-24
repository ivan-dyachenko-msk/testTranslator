//
//  TranslatePresenter.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol TranslatePresenterProtocolInput: TranslateInteractorProtocolOutput {
    func translate(text: String)
    func langFromChanged(from: String)
    func langToChanged(to: String)
    func getArrayForPicker(row: Int) -> String
    func getCountForPicker() -> Int
    func getRows()
    func reverseLang()
    func saveTranslate(_ text: String, translation: String)
}

protocol TranslatePresenterProtocolOutput: class {
    func showTranslatedText(text: String)
    func selectRows(rowFrom: Int, rowTo: Int)
}

class TranslatePresenter: TranslatePresenterProtocolInput {
    
   
    weak var view: TranslateViewControllerProtocolInput!
    var interactor: TranslateInteractorProtocolInput!
    
    func translate(text: String) {
        
        self.interactor.translate(text: text)
    }
    
    func translatedForPresenter(text: String) {
        
        self.view.showTranslatedText(text: text)
    }
    
    func langFromChanged(from: String) {
        
        self.interactor.setLangFrom(from: from)
    }
    
    func langToChanged(to: String) {
        
        self.interactor.setLangTo(to: to)
    }
    
    func getArrayForPicker(row: Int) -> String {
        
        return self.interactor.getArrayForPicker(row: row)
    }
    
    func getCountForPicker() -> Int {
        
        return self.interactor.getCountForPicker()
    }
    
    func getRows() {
       
        self.view.selectRows(rowFrom: self.interactor.getLangFrom(), rowTo: self.interactor.getLangTo())
    }
    
    func reverseLang() {
        
        self.interactor.reverseLang()
        getRows()
    }
    
    func saveTranslate(_ text: String, translation: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.saveTranslate(text, translation: translation)
        }
    }
    
}
