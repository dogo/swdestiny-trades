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
    func didSelectPerson(at: IndexPath)
}

class PeopleListViewController: UIViewController {
    
    let peopleListView = PeopleListView()
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = peopleListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        
        loadDataFromRealm()

        NotificationCenter.default.addObserver(self, selector: #selector(PeopleListViewController.reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
        
        peopleListView.peopleListTableView.didSelectPerson = { [weak self] person in
            self?.navigateToLoansDetailViewController(person: person)
        }
        
        peopleListView.peopleListTableView.didSelectInsetPerson = { [weak self] person in
            self?.peopleListView.peopleListTableView.insert(person)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNavigationItem() {
        self.navigationItem.title = "Expansions"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToNextController(_:)))
    }

    func loadDataFromRealm() {
        let realm = try! Realm()
        let persons = Array(realm.objects(PersonDTO.self))
        peopleListView.peopleListTableView.updatePeopleList(persons)
    }

    @objc private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }

    // MARK: - UIBarButton Actions

    func editButtonTouched(_ sender: Any) {
        toggleTableViewEditable(editable: self.isEditing)
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if self.isEditing {
            toggleTableViewEditable(editable: self.isEditing)
        }
    }

    // MARK: - Helper

    private func toggleTableViewEditable(editable: Bool) {
        super.setEditing(!editable, animated: true)
        peopleListView.peopleListTableView.setEditing(!editable, animated: true)
        navigationItem.leftBarButtonItem?.title = !editable ? "Done" : "Edit"
        navigationItem.leftBarButtonItem?.style = !editable ? .done : .plain
    }

    // MARK: Navigation

    func navigateToNextController(_ sender: Any) {
        let nextController = NewPersonViewController()
        //nextController.delegate = self
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func navigateToLoansDetailViewController(person: PersonDTO) {
        let nextController = LoansDetailViewController()
        nextController.personDTO = person
        self.navigationController?.pushViewController(nextController, animated: true)
    }

}
