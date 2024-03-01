//
//  PeopleListViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol PeopleListViewType where Self: UITableView {

    var didSelectPerson: ((PersonDTO) -> Void)? { get set }

    var peopleListDelegate: PeopleListProtocol? { get set }

    func updateTableViewData(_ peopleList: [PersonDTO])
    func insert(_ people: PersonDTO)
    func toggleTableViewEditable(editable: Bool)
}
