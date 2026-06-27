//
//  BaseTestCase.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

// swiftlint:disable test_case_accessibility
@MainActor
class BaseTestCase {

    var testContainer: TestContainer!
    var testDatabase: DatabaseMock!
    var mockHttpClient: HttpClientMock!
    var mockSWDestinyService: SWDestinyServiceMock!

    init() async throws {
        testContainer = TestContainer()
        mockHttpClient = HttpClientMock()

        testContainer.registerMock(HttpClientProtocol.self) { [weak self] in
            guard let self else { return HttpClientMock() }
            return mockHttpClient
        }

        mockSWDestinyService = SWDestinyServiceMock(httpClient: mockHttpClient)
        testContainer.registerMock(SWDestinyServiceProtocol.self) { [weak self] in
            guard let self else { return SWDestinyServiceMock(httpClient: HttpClientMock()) }
            return mockSWDestinyService
        }

        testDatabase = DatabaseMock()
        print("🟢 Created testDatabase: \(ObjectIdentifier(testDatabase!))")

        let capturedDatabase = testDatabase!
        testContainer.registerMock(DatabaseProtocol.self) {
            print("🟡 Closure returning database: \(ObjectIdentifier(capturedDatabase))")
            return capturedDatabase
        }

        DependencyManager.shared.register(type: HttpClientProtocol.self) { [weak self] in
            guard let self else { return HttpClientMock() }
            return mockHttpClient
        }
    }

    deinit {
        testDatabase = nil
        testContainer = nil
        mockHttpClient = nil
        mockSWDestinyService = nil
    }

    func registerMock<T>(_ type: T.Type, mock: @escaping () -> T) {
        testContainer.registerMock(type, mock: mock)
    }

    func populateTestData(objects: [any Storable]) async throws {
        guard let database = testDatabase else {
            fatalError("testDatabase is nil - setUp was not called or tearDown was called prematurely")
        }
        for object in objects {
            try await database.save(object: object, update: .all)
        }
    }

    @MainActor
    func waitForLoadingToComplete(viewModel: BaseViewModel, timeout: TimeInterval = 1.0) async -> Bool {
        let startTime = Date()
        let sleepInterval: UInt64 = 10_000_000 // 10ms between checks

        while viewModel.isLoading {
            let elapsed = Date().timeIntervalSince(startTime)
            if elapsed >= timeout {
                return false
            }

            try? await Task.sleep(nanoseconds: sleepInterval)
        }
        return true
    }

    /// Polls a condition until it becomes true or the timeout elapses. Useful for
    /// fire-and-forget `Task`-based view model methods that have no awaitable handle.
    @MainActor
    func waitUntil(timeout: TimeInterval = 2.0, _ condition: @escaping @MainActor () -> Bool) async {
        let start = Date()
        while !condition() {
            if Date().timeIntervalSince(start) >= timeout { return }
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }
    }
}

// swiftlint:enable test_case_accessibility
