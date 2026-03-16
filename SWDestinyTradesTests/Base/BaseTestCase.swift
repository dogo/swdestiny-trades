//
//  BaseTestCase.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

// swiftlint:disable test_case_accessibility
@MainActor
class BaseTestCase: XCTestCase {

    var testContainer: TestContainer!
    var testDatabase: DatabaseMock!
    var mockHttpClient: HttpClientMock!
    var mockSWDestinyService: SWDestinyServiceMock!

    override func setUp() async throws {
        try await super.setUp()

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

    override func tearDown() async throws {
        testDatabase = nil
        testContainer = nil
        mockHttpClient = nil
        mockSWDestinyService = nil

        try await super.tearDown()
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
}

// swiftlint:enable test_case_accessibility
