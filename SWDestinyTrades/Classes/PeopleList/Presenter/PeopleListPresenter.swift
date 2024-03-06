//
//  PeopleListPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol PeopleListPresenterProtocol: AnyObject {
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void)
    func loadDataFromRealm()
    func setNavigationTitle()
    func navigateToLoansDetail(person: PersonDTO)
}

final class PeopleListPresenter: PeopleListPresenterProtocol {

    private let database: DatabaseProtocol?
    private let navigator: PeopleListNavigator

    private weak var controller: PeopleListViewControllerProtocol?

    init(controller: PeopleListViewControllerProtocol?,
         database: DatabaseProtocol?,
         navigator: PeopleListNavigator) {
        self.controller = controller
        self.database = database
        self.navigator = navigator

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NotificationKey.reloadTableViewNotification,
                                               object: nil)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        let editButton = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTouched(_:)))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToNextController(_:)))
        completion([editButton, addButton])
    }

    func loadDataFromRealm() {
        try? database?.fetch(PersonDTO.self, predicate: nil, sorted: nil) { [weak self] persons in
            self?.controller?.updateTableViewData(persons)
        }
    }

    func setNavigationTitle() {
        controller?.setNavigationTitle(L10n.people)
    }

    func navigateToLoansDetail(person: PersonDTO) {
        navigator.navigate(to: .loanDetail(database: database, with: person))
    }

    // MARK: - UIBarButton Actions

    @objc
    private func editButtonTouched(_ sender: Any) {
        let isEditing = controller?.isEditing ?? false
        toggleTableViewEditable(editable: isEditing)
    }

    @objc
    private func navigateToNextController(_ sender: Any) {
        let isEditing = controller?.isEditing ?? false
        if isEditing {
            toggleTableViewEditable(editable: isEditing)
        }
        navigator.navigate(to: .newPerson(with: self))
    }

    // MARK: - Helper

    private func toggleTableViewEditable(editable: Bool) {
        let title = !editable ? L10n.done : L10n.edit
        controller?.toggleTableViewEditable(editable: editable, title: title)
    }

    @objc
    private func reloadTableView(_ notification: NSNotification) {
        loadDataFromRealm()
    }
}

extension PeopleListPresenter: PeopleListProtocol {

    func remove(person: PersonDTO) {
        try? database?.delete(object: person)
    }

    func insert(person: PersonDTO) {
        try? database?.save(object: person)
    }
}

extension PeopleListPresenter: UpdateTableDataDelegate {

    func insertNew(person: PersonDTO) {
        controller?.insert(person)
    }
}
