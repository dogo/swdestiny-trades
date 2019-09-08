//
//  PeopleListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol UpdateTableDataDelegate: AnyObject {
    func insertNew(person: PersonDTO)
}

final class PeopleListViewController: UIViewController, UpdateTableDataDelegate {

    private lazy var peopleListView = PeopleListTableView(delegate: self)
    private lazy var navigator = PeopleListNavigator(self.navigationController)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
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

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NotificationKey.reloadTableViewNotification, object: nil)

        peopleListView.didSelectPerson = { [weak self] person in
            self?.navigateToLoansDetailViewController(person: person)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.people
        peopleListView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private

    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToNextController(_:)))
    }

    func loadDataFromRealm() {
        try? database?.fetch(PersonDTO.self, predicate: nil, sorted: nil) { [weak self] persons in
            self?.peopleListView.updatePeopleList(persons)
        }
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }

    // MARK: - <UpdateTableDataDelegate>

    internal func insertNew(person: PersonDTO) {
        peopleListView.insert(person)
    }

    // MARK: - UIBarButton Actions

    @objc
    func editButtonTouched(_ sender: Any) {
        toggleTableViewEditable(editable: self.isEditing)
    }

    // MARK: - Helper

    private func toggleTableViewEditable(editable: Bool) {
        super.setEditing(!editable, animated: true)
        peopleListView.toggleTableViewEditable(editable: editable)
        navigationItem.leftBarButtonItem?.title = !editable ? L10n.done : L10n.edit
    }

    // MARK: - Navigation

    @objc
    func navigateToNextController(_ sender: Any) {

        if self.isEditing {
            toggleTableViewEditable(editable: self.isEditing)
        }
        self.navigator.navigate(to: .newPerson(with: self))
    }

    func navigateToLoansDetailViewController(person: PersonDTO) {
        self.navigator.navigate(to: .loanDetail(database: self.database, with: person))
    }
}

extension PeopleListViewController: PeopleListProtocol {

    func remove(person: PersonDTO) {
        try? self.database?.delete(object: person)
    }

    func insert(person: PersonDTO) {
        try? self.database?.save(object: person)
    }
}
