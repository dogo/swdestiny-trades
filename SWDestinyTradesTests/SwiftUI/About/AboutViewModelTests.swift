//
//  AboutViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class AboutViewModelTests: XCTestCase {

    private var sut: AboutViewModel!
    private var coordinatorMock: NavigationCoordinatorMock!

    override func setUp() {
        super.setUp()
        coordinatorMock = NavigationCoordinatorMock()
        sut = AboutViewModel()
    }

    override func tearDown() {
        sut = nil
        coordinatorMock = nil
        super.tearDown()
    }

    func testOpenWebsiteNavigatesToWebview() throws {
        sut.openWebsite(using: coordinatorMock)

        let expectedURL = try XCTUnwrap(URL(string: L10n.swdestinydbWebsite))
        XCTAssertTrue(coordinatorMock.didNavigate(to: .webview(url: expectedURL)))
    }

    func testOpenWebsiteNavigatesOnce() throws {
        sut.openWebsite(using: coordinatorMock)

        let expectedURL = try XCTUnwrap(URL(string: L10n.swdestinydbWebsite))
        XCTAssertEqual(coordinatorMock.navigationCallCount(to: .webview(url: expectedURL)), 1)
    }
}
