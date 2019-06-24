//
//  SavedViewController.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 22/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol SavedViewControllerInput: SavedPresenterProtocolOutput {
    
}

class SavedViewController: UIViewController, SavedViewControllerInput {
    
    var presenter: SavedPresenterProtocolInput!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        self.presenter.removeAllRecords()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SavedAssembly.shared.assembly(viewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.configureView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func updateSavedTableView() {
        self.tableView.reloadData()
    }
    
    func showSavedTableView() {
        tableView.register(kTableViewCellNiB, forCellReuseIdentifier: kReusableCellIdentifier)
        tableView.dataSource = self
    }
    
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
   
    private var kTableViewCellNiB : UINib {
        return UINib(nibName: "SavedTableViewCell", bundle: nil)
    }
    
    private var kReusableCellIdentifier : String {
        return "kReusableCellIdentifier"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.presenter.numberOfRowInSections)
        return self.presenter.numberOfRowInSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReusableCellIdentifier, for: indexPath) as! SavedTableViewCell
        cell.model = presenter.dataForCell(with: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as! SavedTableViewCell
        
        self.presenter.removeRecord(word: cell.model.0, translation: cell.model.1)
    }
}

extension SavedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" && searchText != " " {
            self.presenter.wordSearching(text: searchText)
        } else if searchText == "" {
            self.presenter.configureView()
            print("clear")
        }
    }
}
