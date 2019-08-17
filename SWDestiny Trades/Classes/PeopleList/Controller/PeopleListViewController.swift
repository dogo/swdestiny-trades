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

    private let peopleListView = PeopleListView()
    private lazy var navigator = PeopleListNavigator(self.navigationController)

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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

        peopleListView.peopleListTableView.didSelectPerson = { [weak self] person in
            self?.navigateToLoansDetailViewController(person: person)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.people
        peopleListView.peopleListTableView.reloadData()
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
        let persons = Array(RealmManager.shared.realm.objects(PersonDTO.self))
        peopleListView.peopleListTableView.updatePeopleList(persons)
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }

    // MARK: - <UpdateTableDataDelegate>

    internal func insertNew(person: PersonDTO) {
        peopleListView.peopleListTableView.insert(person)
    }

    // MARK: - UIBarButton Actions

    @objc
    func editButtonTouched(_ sender: Any) {
        toggleTableViewEditable(editable: self.isEditing)
    }

    // MARK: - Helper

    private func toggleTableViewEditable(editable: Bool) {
        super.setEditing(!editable, animated: true)
        peopleListView.peopleListTableView.toggleTableViewEditable(editable: editable)
        navigationItem.leftBarButtonItem?.title = !editable ? L10n.done : L10n.edit
    }

    // MARK: - Navigation

    @objc
    func navigateToNextController(_ sender: Any) {

        if self.isEditing {
            toggleTableViewEditable(editable: self.isEditing)
        }

        let nextController = NewPersonViewController()
        nextController.delegate = self
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func navigateToLoansDetailViewController(person: PersonDTO) {
        self.navigator.navigate(to: .loanDetail(with: person))
    }

}
