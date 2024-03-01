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

final class PeopleListPresenterSpy: PeopleListProtocol {

    private(set) var didCallRemoveValues: [PersonDTO] = []
    func remove(person: PersonDTO) {
        didCallRemoveValues.append(person)
    }

    private(set) var didCallInsertValues: [PersonDTO] = []
    func insert(person: PersonDTO) {
        didCallInsertValues.append(person)
    }
}
