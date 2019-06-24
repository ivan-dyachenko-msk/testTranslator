//
//  SavedAssembly.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

struct SavedAssembly {
    
    static var shared = SavedAssembly()
    
    func assembly(viewController: SavedViewController) {
        let presenter = SavedPresenter()
        let interactor = SavedInteractor()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
}
