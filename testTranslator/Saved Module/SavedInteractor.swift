//
//  SavedInteractor.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol  SavedInteractorProtocolInput: class {
    func loadAllWords () -> [(String, String)]
    func loadWord(_ text: String ) -> [(String, String)]
    func removeWord(word: String, translation: String)
    func removeAllWords()
}

protocol SavedInteractorProtocolOutput: class {
    func updateView()
}

class SavedInteractor: SavedInteractorProtocolInput {
   
    var presenter: SavedPresenterProtocolInput!

    func loadAllWords () -> [(String, String)] {
        return CoreDataManager.sharedInstance.getAllWordFromDataBase()
    }
    
    func loadWord(_ text: String ) -> [(String, String)] {
        let t = text.trimmingCharacters(in: .whitespaces).lowercased()
        return CoreDataManager.sharedInstance.getRecords(with: t)
    }
    
    func removeWord(word: String, translation: String) {
        CoreDataManager.sharedInstance.removeRecord(word: word, translation: translation)
        presenter.updateView()
    }
    
    func removeAllWords() {
        CoreDataManager.sharedInstance.removeAllRecords()
        presenter.updateView()
    }
}

