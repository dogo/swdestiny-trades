//
//  PeopleListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol PeopleListProtocol: AnyObject {
    func remove(person: PersonDTO)
    func insert(person: PersonDTO)
}

final class PeopleListDatasource: NSObject, UITableViewDataSource {
    private var tableView: UITableView?
    private var persons: [PersonDTO] = []
    private weak var delegate: PeopleListProtocol?

    required init(tableView: UITableView, delegate: PeopleListProtocol) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        tableView.register(cellType: PersonCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PersonCell.self)
        cell.configureCell(personDTO: persons[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    func getPerson(at index: IndexPath) -> PersonDTO? {
        return persons[index.row]
    }

    func insert(personArray: [PersonDTO]) {
        persons = personArray
        tableView?.reloadData()
    }

    func insert(person: PersonDTO) {
        delegate?.insert(person: person)
        persons.append(person)
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        delegate?.remove(person: persons[indexPath.row])
        persons.remove(at: indexPath.row)
    }
}
