//
//  PeopleListViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 06/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class PeopleListViewSpy: UITableView, PeopleListViewType {

    var didSelectPerson: ((PersonDTO) -> Void)?
    var peopleListDelegate: PeopleListProtocol?

    private(set) var didCallUpdateTableViewDataValues = [PersonDTO]()
    func updateTableViewData(_ peopleList: [PersonDTO]) {
        didCallUpdateTableViewDataValues.append(contentsOf: peopleList)
    }

    private(set) var didICallnsertValues = [PersonDTO]()
    func insert(_ people: PersonDTO) {
        didICallnsertValues.append(people)
    }

    private(set) var didICallToggleTableViewEditableValues = [Bool]()
    func toggleTableViewEditable(editable: Bool) {
        didICallToggleTableViewEditableValues.append(editable)
    }
}
