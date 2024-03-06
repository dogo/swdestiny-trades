//
//  PeopleListPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class PeopleListPresenterSpy: PeopleListPresenterProtocol, PeopleListProtocol {

    private(set) var didCallSetupNavigationItemsCount = 0
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        didCallSetupNavigationItemsCount += 1
        completion([])
    }

    private(set) var didCallLoadDataFromRealmCount = 0
    func loadDataFromRealm() {
        didCallLoadDataFromRealmCount += 1
    }

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallNavigateToLoansDetailValues: [PersonDTO] = []
    func navigateToLoansDetail(person: PersonDTO) {
        didCallNavigateToLoansDetailValues.append(person)
    }

    private(set) var didCallRemoveValues: [PersonDTO] = []
    func remove(person: PersonDTO) {
        didCallRemoveValues.append(person)
    }

    private(set) var didCallInsertValues: [PersonDTO] = []
    func insert(person: PersonDTO) {
        didCallInsertValues.append(person)
    }
}
