//
//  PeopleListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListTableView: UITableView, PeopleListViewType {

    var didSelectPerson: ((PersonDTO) -> Void)?

    weak var peopleListDelegate: PeopleListProtocol?

    private var tableViewDatasource: PeopleListDatasource?

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate = self
        backgroundColor = .blackWhite
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(_ peopleList: [PersonDTO]) {
        tableViewDatasource = PeopleListDatasource(tableView: self, delegate: peopleListDelegate)
        tableViewDatasource?.insert(personArray: peopleList)
    }

    func insert(_ people: PersonDTO) {
        tableViewDatasource?.insert(person: people)
    }

    func toggleTableViewEditable(editable: Bool) {
        setEditing(!editable, animated: true)
    }

    // MARK: <BaseDelegate>

    func didSelectRowAt(index: IndexPath) {
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
