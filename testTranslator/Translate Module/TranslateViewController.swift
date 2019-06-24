//
//  TranslateViewController.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 20/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol TranslateViewControllerProtocolInput: TranslatePresenterProtocolOutput {
    func showTranslatedText(text: String)
}

class TranslateViewController: UIViewController, TranslateViewControllerProtocolInput {
    
    var presenter: TranslatePresenterProtocolInput!
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextLabel: UILabel!
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    
    @IBAction func reverseLanguagesButtonPressed(_ sender: UIButton) {
        self.inputTextView.text = ""
        self.presenter.reverseLang()
    }
    
    @IBAction func translateButtonPressed(_ sender: UIButton) {
        self.presenter.translate(text: self.inputTextView.text)
        guard !inputTextView.text.isEmpty && !outputTextLabel.text!.isEmpty else { return }
        
        self.presenter.saveTranslate(inputTextView.text, translation: outputTextLabel.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TranslateAssembly.shared.assembly(viewController: self)
        self.presenter.getRows()
        self.fromPicker.delegate = self
        self.fromPicker.dataSource = self
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func selectRows(rowFrom: Int, rowTo: Int) {
        DispatchQueue.main.async {
            self.fromPicker.selectRow(rowFrom, inComponent: 0, animated: false)
            self.toPicker.selectRow(rowTo, inComponent: 0, animated: false)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showTranslatedText(text: String) {
        DispatchQueue.main.async {
            self.outputTextLabel.text = text
        }
    }
}

extension TranslateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.presenter.getCountForPicker()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let lang = self.presenter.getArrayForPicker(row: row)
        
        switch pickerView.tag {
        case 0: self.presenter.langFromChanged(from: lang)
        case 1: self.presenter.langToChanged(to: lang)
        default: break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        for view in pickerView.subviews {
            view.frame.size.height = 0
            view.contentScaleFactor = 0.5
        }
        return self.presenter.getArrayForPicker(row: row)
    }
}
