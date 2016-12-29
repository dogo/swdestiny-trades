//
//  LoansViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

protocol LoansListViewDelegate {
    func insertNew(person: PersonDTO)
    func didSelectSet(at: IndexPath)
}

class LoansViewController: UIViewController, LoansListViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var tableViewDatasource: LoansListDatasource?
    var tableViewDelegate: LoansListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadDataFromRealm()
    }

    func loadDataFromRealm() {
        let realm = try! Realm()
        let persons = Array(realm.objects(PersonDTO.self))
        print(persons)
        tableViewDatasource?.insert(personArray: persons)
        tableView?.reloadData()
    }

    func setupTableView() {
        tableViewDatasource = LoansListDatasource()
        tableViewDelegate = LoansListDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    // MARK: IBActions

    @IBAction func editButtonTouched(_ sender: Any) {
        if self.isEditing {
            super.setEditing(false, animated: true)
            tableView?.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "Edit"
            navigationItem.leftBarButtonItem?.style = .plain
        } else {
            super.setEditing(true, animated: true)
            tableView?.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "Done"
            navigationItem.leftBarButtonItem?.style = .done
        }
    }

    internal func insertNew(person: PersonDTO) {
        tableViewDatasource?.insert(person: person)
        tableView?.reloadData()
    }

    internal func didSelectSet(at: IndexPath) {

    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewLoanSegue" {
            if let nextViewController = segue.destination as? NewLoanViewController {
                nextViewController.delegate = self
            }
        }
    }
}
