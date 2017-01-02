//
//  PeopleListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

class PeopleListDatasource: NSObject, UITableViewDataSource {

    private var persons: [PersonDTO] = []

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoanCell.cellIdentifier(), for: indexPath) as? LoanCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(personDTO: persons[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(persons[indexPath.row])
                persons.remove(at: indexPath.row)
            }
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

    public func getPersonAt(index: IndexPath) -> PersonDTO? {
        return persons[index.row]
    }

    public func insert(personArray: [PersonDTO]) {
        persons = personArray
    }

    public func insert(person: PersonDTO) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(person, update: true)
            persons.append(person)
        }
    }
}

class PeopleListDelegate: NSObject, UITableViewDelegate {

    private let delegate: PeopleListViewDelegate

    init(_ delegate: PeopleListViewDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectSet(at: indexPath)
    }
}
