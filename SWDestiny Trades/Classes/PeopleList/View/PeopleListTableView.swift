//
//  PeopleListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListTableView: UITableView, BaseDelegate {

    var didSelectPerson: ((PersonDTO) -> Void)?

    fileprivate var tableViewDatasource: PeopleListDatasource?
    let peopleList = PeopleList()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        peopleList.delegate = self
        tableViewDatasource = PeopleListDatasource(tableView: self, delegate: peopleList)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePeopleList(_ peopleList: [PersonDTO]) {
        tableViewDatasource?.insert(personArray: peopleList)
    }

    func insert(_ people: PersonDTO) {
        tableViewDatasource?.insert(person: people)
    }

    func toggleTableViewEditable(editable: Bool) {
        self.setEditing(!editable, animated: true)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRow(at index: IndexPath) {
        if let person = tableViewDatasource?.getPerson(at: index) {
            didSelectPerson?(person)
        }
    }
}
