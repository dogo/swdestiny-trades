//
//  UpdateTableDataDelegateSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class UpdateTableDataDelegateSpy: UpdateTableDataDelegate {

    private(set) var didCallInsertNew = [PersonDTO]()
    func insertNew(person: PersonDTO) {
        didCallInsertNew.append(person)
    }
}
