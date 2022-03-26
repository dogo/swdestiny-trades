//
//  PeopleListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListTableView: UITableView {
    var didSelectPerson: ((PersonDTO) -> Void)?

    private var tableViewDatasource: PeopleListDatasource?

    required init(frame: CGRect = .zero, style: UITableView.Style = .plain, delegate: PeopleListProtocol) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = PeopleListDatasource(tableView: self, delegate: delegate)
        backgroundColor = .blackWhite
    }

    @available(*, unavailable)
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
        setEditing(!editable, animated: true)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let person = tableViewDatasource?.getPerson(at: index) {
            didSelectPerson?(person)
        }
    }
}

extension PeopleListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
