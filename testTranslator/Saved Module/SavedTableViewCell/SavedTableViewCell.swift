//
//  SavedTableViewCell.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 24/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class SavedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originalText: UILabel!
    
    @IBOutlet weak var translatedText: UILabel!
    
    var model: (String, String)! {
        didSet {
            self.originalText.text = model.0
            self.translatedText.text = model.1
        }
    }
    
}
