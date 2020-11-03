//
//  RealmDatabaseHelper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/02/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestiny_Trades

enum RealmDatabaseHelper {
    static func createMemoryDatabase(identifier: String) -> RealmDatabase? {
        return try? RealmDatabase(configuration: .inMemory(identifier: identifier))
    }
}
