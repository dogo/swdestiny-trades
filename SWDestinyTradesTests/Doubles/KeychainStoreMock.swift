//
//  KeychainStoreMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class KeychainStoreMock: KeychainStoreProtocol {
    private(set) var storage: [String: Data] = [:]
    var setSucceeds = true

    func data(for key: String) -> Data? {
        storage[key]
    }

    @discardableResult
    func set(_ data: Data, for key: String) -> Bool {
        guard setSucceeds else { return false }
        storage[key] = data
        return true
    }

    func delete(_ key: String) {
        storage[key] = nil
    }
}
