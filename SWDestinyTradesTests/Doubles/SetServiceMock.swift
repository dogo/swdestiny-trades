//
//  SetServiceMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class SetServiceMock: SetServiceProtocol {

    var retrieveSetListResult: [SetDTO] = []
    var retrieveSetListError: Error?
    private(set) var retrieveSetListCallCount = 0
    func retrieveSetList() async throws -> [SetDTO] {
        retrieveSetListCallCount += 1
        if let error = retrieveSetListError {
            throw error
        }
        return retrieveSetListResult
    }
}
