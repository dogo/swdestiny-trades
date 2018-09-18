//
//  PeopleListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class PeopleListDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    fileprivate var persons: [PersonDTO] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
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

    public func getPerson(at index: IndexPath) -> PersonDTO? {
        return persons[index.row]
    }

    public func insert(personArray: [PersonDTO]) {
        persons = personArray
        tableView?.reloadData()
    }

    public func insert(person: PersonDTO) {
        do {
            try RealmManager.shared.realm.write {
                RealmManager.shared.realm.add(person, update: true)
                persons.append(person)
            }
            tableView?.reloadData()
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    private func remove(at indexPath: IndexPath) {
        do {
            try RealmManager.shared.realm.write {
                RealmManager.shared.realm.delete(persons[indexPath.row])
                persons.remove(at: indexPath.row)
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }
}
