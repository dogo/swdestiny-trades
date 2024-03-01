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

    private lazy var peopleListView: PeopleListViewType = PeopleListTableView()
    private lazy var navigator = PeopleListNavigator(self)
    private let database: DatabaseProtocol?

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
        peopleListView.peopleListDelegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = peopleListView
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

        navigationItem.title = L10n.people
        peopleListView.reloadData()
    }

    // MARK: - Private

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTouched(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToNextController(_:)))
    }

    func loadDataFromRealm() {
        try? database?.fetch(PersonDTO.self, predicate: nil, sorted: nil) { [weak self] persons in
            self?.peopleListView.updateTableViewData(persons)
        }
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }

    // MARK: - <UpdateTableDataDelegate>

    func insertNew(person: PersonDTO) {
        peopleListView.insert(person)
    }

    // MARK: - UIBarButton Actions

    @objc
    func editButtonTouched(_ sender: Any) {
        toggleTableViewEditable(editable: isEditing)
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
        if isEditing {
            toggleTableViewEditable(editable: isEditing)
        }
        navigator.navigate(to: .newPerson(with: self))
    }

    func navigateToLoansDetailViewController(person: PersonDTO) {
        navigator.navigate(to: .loanDetail(database: database, with: person))
    }
}

extension PeopleListViewController: PeopleListProtocol {
    func remove(person: PersonDTO) {
        try? database?.delete(object: person)
    }

    func insert(person: PersonDTO) {
        try? database?.save(object: person)
    }
}
