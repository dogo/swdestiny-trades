//
//  ConcurrencyErrorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class ConcurrencyErrorTests {

    @Test
    func test_errorDescription_returnsExpectedMessages() {
        #expect(ConcurrencyError.taskCancelled.localizedDescription == "Operation was cancelled")
        #expect(ConcurrencyError.mainActorTimeout.localizedDescription == "Main actor operation timed out")

        let error = ConcurrencyError.realmAccessError(SampleLocalizedError())
        #expect(error.localizedDescription == "Database error: sample failure")
    }

    @Test
    func test_isCancellation_recognizesCancellationErrors() {
        #expect(ConcurrencyError.isCancellation(CancellationError()))
        #expect(ConcurrencyError.isCancellation(ConcurrencyError.taskCancelled))
        #expect(ConcurrencyError.isCancellation(APIError.requestCancelled))
        #expect(ConcurrencyError.isCancellation(URLError(.cancelled)))
    }

    @Test
    func test_isCancellation_rejectsNonCancellationErrors() {
        #expect(!ConcurrencyError.isCancellation(APIError.invalidData))
        #expect(!ConcurrencyError.isCancellation(URLError(.badURL)))
        #expect(!ConcurrencyError.isCancellation(SampleLocalizedError()))
    }

    @Test
    func test_from_mapsCancellationErrorToTaskCancelled() {
        let result = ConcurrencyError.from(CancellationError())

        guard case .taskCancelled = result else {
            Issue.record("Expected taskCancelled, got \(result)")
            return
        }
    }

    @Test
    func test_from_preservesConcurrencyError() {
        let result = ConcurrencyError.from(ConcurrencyError.mainActorTimeout)

        guard case .mainActorTimeout = result else {
            Issue.record("Expected mainActorTimeout, got \(result)")
            return
        }
    }

    @Test
    func test_from_wrapsGenericErrorAsRealmAccessError() {
        let result = ConcurrencyError.from(SampleLocalizedError())

        guard case let .realmAccessError(error) = result else {
            Issue.record("Expected realmAccessError, got \(result)")
            return
        }

        #expect(error.localizedDescription == "sample failure")
    }
}

private struct SampleLocalizedError: LocalizedError {
    var errorDescription: String? {
        "sample failure"
    }
}
