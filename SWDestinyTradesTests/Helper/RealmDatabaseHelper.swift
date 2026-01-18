//
//  RealmDatabaseHelper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/02/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

enum RealmDatabaseHelper {
    @MainActor
    static func createMemoryRealmManager(identifier: String) async -> RealmManager? {
        return try? await RealmManager.create(configuration: .inMemory(identifier: identifier))
    }
}
