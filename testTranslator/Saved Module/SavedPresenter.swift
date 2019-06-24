//
//  SavedPresenter.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol SavedPresenterProtocolInput: SavedInteractorProtocolOutput {
    func updateView()
    func configureView()
    func dataForCell( with index: Int) -> (String,String)
    func removeRecord(word: String, translation: String)
    func removeAllRecords()
    func wordSearching(text: String)
    var numberOfRowInSections : Int { get }
}

protocol SavedPresenterProtocolOutput: class {
    func updateSavedTableView()
    func showSavedTableView()
}

class SavedPresenter: SavedPresenterProtocolInput {
    
    var view: SavedViewControllerInput!
    var interactor: SavedInteractorProtocolInput!
    
    private var text : [(String,String)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.updateSavedTableView()
            }
        }
    }
    
    func updateView() {
        self.text = self.interactor.loadAllWords()
    }
    
    func configureView() {
        text = self.interactor.loadAllWords()
        self.view.showSavedTableView()
    }
    
    var numberOfRowInSections : Int {
        return self.text.count
    }
    
    func dataForCell( with index: Int) -> (String,String) {
        return self.text[index]
    }
    
    func removeRecord(word: String, translation: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.removeWord(word: word, translation: translation)
        }
    }
    
    func removeAllRecords() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.removeAllWords()
        }
    }
    
    func wordSearching(text: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.text = self.interactor.loadWord(text)
        }
    }
}
