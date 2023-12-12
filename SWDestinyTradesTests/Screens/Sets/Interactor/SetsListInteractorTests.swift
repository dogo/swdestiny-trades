//
//  SetsListInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListInteractorTests: XCTestCase {

    private var sut: SetsListInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUpWithError() throws {
        client = HttpClientMock()
        service = SWDestinyService(client: client)
        sut = SetsListInteractor(service: service)
    }

    override func tearDownWithError() throws {
        client = nil
        service = nil
        sut = nil
    }

    func testRetrieveSetsWithSuccess() async throws {
        let setList = try await sut.retrieveSets()
        XCTAssertEqual(setList.count, 20)
    }

    func testFailToRetrieveSets() async throws {
        client.error = true

        // await XCTAssertThrowsError(try await sut.retrieveSets())
    }
}
