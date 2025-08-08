//
//  SetsListInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class SetsListInteractorTests: BaseTestCase {

    private var sut: SetsListInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUp() {
        super.setUp()
        client = DependencyManager.shared.resolve(type: HttpClientProtocol.self, mode: .shared) as? HttpClientMock
        service = SWDestinyService()
        sut = SetsListInteractor(service: service)
    }

    override func tearDown() {
        client = nil
        service = nil
        sut = nil
        super.tearDown()
    }

    func test_retrieve_sets_with_success() async throws {
        client.fileName = "sets"
        let setList = try await sut.retrieveSets()

        XCTAssertEqual(setList.count, 12)
    }

    func test_fail_to_retrieve_sets() async throws {
        client.error = true

        do {
            _ = try await sut.retrieveSets()
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertNotNil(error, "error must be not-nil")
        }
    }
}
