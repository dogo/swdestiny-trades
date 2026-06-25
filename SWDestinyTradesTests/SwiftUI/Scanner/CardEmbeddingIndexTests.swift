//
//  CardEmbeddingIndexTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class CardEmbeddingIndexTests: XCTestCase {

    private let entries = [
        CardEmbeddingEntry(code: "A", vector: [1, 0, 0]),
        CardEmbeddingEntry(code: "B", vector: [0, 1, 0]),
        CardEmbeddingEntry(code: "C", vector: [0, 0, 1])
    ]

    func test_nearestToAny_picksBestAcrossQueryOrientations() {
        let index = CardEmbeddingIndex(entries: entries)

        // One orientation is noise, the other points at C.
        let matches = index.nearest(toAny: [[0.6, 0.4, 0], [0, 0, 1]], limit: 1)

        XCTAssertEqual(matches.first?.code, "C")
        XCTAssertEqual(matches.first?.score ?? 0, 1.0, accuracy: 0.0001)
    }

    func test_nearestToAny_ignoresVectorMagnitude() {
        let index = CardEmbeddingIndex(entries: entries)

        XCTAssertEqual(index.nearest(toAny: [[0, 50, 0]], limit: 1).first?.code, "B")
    }

    func test_nearestToAny_respectsLimitAndOrdering() {
        let index = CardEmbeddingIndex(entries: entries)

        let matches = index.nearest(toAny: [[0.6, 0.8, 0]], limit: 2)

        XCTAssertEqual(matches.map(\.code), ["B", "A"])
    }

    func test_nearestToAny_producesFiniteScoresForDegenerateQuery() {
        let index = CardEmbeddingIndex(entries: entries)

        XCTAssertTrue(index.nearest(toAny: [[.nan, .nan, .nan]]).allSatisfy { $0.score.isFinite })
    }

    func test_nearestToAny_emptyOnDimensionMismatch() {
        let index = CardEmbeddingIndex(entries: entries)

        XCTAssertTrue(index.nearest(toAny: [[1, 0]]).isEmpty)
    }
}
