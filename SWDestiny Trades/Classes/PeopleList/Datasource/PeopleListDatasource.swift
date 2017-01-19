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

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: PersonCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PersonCell.self)
        cell.configureCell(personDTO: persons[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        try! RealmManager.shared.realm.write {
            RealmManager.shared.realm.add(person, update: true)
            persons.append(person)
        }
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        try! RealmManager.shared.realm.write {
            RealmManager.shared.realm.delete(persons[indexPath.row])
            persons.remove(at: indexPath.row)
        }
    }
}

class PeopleList: NSObject, UITableViewDelegate {

    weak var delegate: BaseDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
