//
//  PeopleListViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class PeopleListViewControllerSpy: UIViewController, PeopleListViewControllerProtocol {

    private(set) var didCallUpdateTableViewDataValues: [PersonDTO] = []
    func updateTableViewData(_ peopleList: [PersonDTO]) {
        didCallUpdateTableViewDataValues.append(contentsOf: peopleList)
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }

    private(set) var didCallToggleTableViewEditableValues: [(editable: Bool, title: String)] = []
    func toggleTableViewEditable(editable: Bool, title: String) {
        didCallToggleTableViewEditableValues.append((editable, title))
    }

    private(set) var didCallInsertValues: [PersonDTO] = []
    func insert(_ person: PersonDTO) {
        didCallInsertValues.append(person)
    }
}
