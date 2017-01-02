//
//  PeopleListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

protocol PeopleListViewDelegate {
    func insertNew(person: PersonDTO)
    func didSelectSet(at: IndexPath)
}

class PeopleListViewController: UIViewController, PeopleListViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var tableViewDatasource: PeopleListDatasource?
    var tableViewDelegate: PeopleListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadDataFromRealm()

        NotificationCenter.default.addObserver(self, selector: #selector(PeopleListViewController.reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: path, animated: animated)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadDataFromRealm() {
        let realm = try! Realm()
        let persons = Array(realm.objects(PersonDTO.self))
        tableViewDatasource?.insert(personArray: persons)
        tableView?.reloadData()
    }

    func setupTableView() {
        tableViewDatasource = PeopleListDatasource()
        tableViewDelegate = PeopleListDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    @objc private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }

    // MARK: - IBActions

    @IBAction func editButtonTouched(_ sender: Any) {
        toggleTableViewEditable(editable: self.isEditing)
    }

    // MARK: - <PeopleListViewDelegate>

    internal func insertNew(person: PersonDTO) {
        tableViewDatasource?.insert(person: person)
        tableView?.reloadData()
    }

    internal func didSelectSet(at index: IndexPath) {
        performSegue(withIdentifier: "LoanDetailSegue", sender: tableViewDatasource?.getPersonAt(index: index))
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if self.isEditing {
            toggleTableViewEditable(editable: self.isEditing)
        }

        if segue.identifier == "NewPersonSegue" {
            if let navController = segue.destination as? UINavigationController {
                if let nextViewController = navController.topViewController as? NewPersonViewController {
                    nextViewController.delegate = self
                }
            }
        } else if segue.identifier == "LoanDetailSegue" {
            if let nextViewController = segue.destination as? LoansDetailViewController {
                nextViewController.personDTO = (sender as? PersonDTO)
            }
        }
    }

    // MARK: - Helper

    private func toggleTableViewEditable(editable: Bool) {
        super.setEditing(!editable, animated: true)
        tableView?.setEditing(!editable, animated: true)
        navigationItem.leftBarButtonItem?.title = !editable ? "Done" : "Edit"
        navigationItem.leftBarButtonItem?.style = !editable ? .done : .plain
    }
}
