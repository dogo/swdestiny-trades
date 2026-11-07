//
//  SearchServiceMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class SearchServiceMock: SearchServiceProtocol {

    var searchResult: [CardDTO] = []
    var searchError: Error?
    private(set) var searchCallCount = 0
    func search(query: String) async throws -> [CardDTO] {
        searchCallCount += 1
        if let error = searchError {
            throw error
        }
        return searchResult
    }
}
