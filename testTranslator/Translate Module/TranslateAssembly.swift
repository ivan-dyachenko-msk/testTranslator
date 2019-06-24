//
//  TranslateAssembly.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

struct TranslateAssembly {
    
    static var shared = TranslateAssembly()
    
    func assembly(viewController: TranslateViewController) {
        let dataManager = ApiWrapper()
        let presenter = TranslatePresenter()
        let interactor = TranslateInteractor()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.wrapper = dataManager
        dataManager.interactor = interactor
    }
}
