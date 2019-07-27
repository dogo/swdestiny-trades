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

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = PeopleListDatasource(tableView: self)
        self.backgroundColor = .white
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
        self.setEditing(!editable, animated: true)
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
