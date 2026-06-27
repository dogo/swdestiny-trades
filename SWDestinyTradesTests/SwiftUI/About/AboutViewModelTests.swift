//
//  AboutViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class AboutViewModelTests {

    private var sut: AboutViewModel!
    private var coordinatorMock: NavigationCoordinatorMock!

    init() {
        coordinatorMock = NavigationCoordinatorMock()
        sut = AboutViewModel()
    }

    deinit {
        sut = nil
        coordinatorMock = nil
    }

    @Test
    func testOpenWebsiteNavigatesToWebview() throws {
        sut.openWebsite(using: coordinatorMock)

        let expectedURL = try #require(URL(string: L10n.swdestinydbWebsite))
        #expect(coordinatorMock.didNavigate(to: .webview(url: expectedURL)))
    }

    @Test
    func testOpenWebsiteNavigatesOnce() throws {
        sut.openWebsite(using: coordinatorMock)

        let expectedURL = try #require(URL(string: L10n.swdestinydbWebsite))
        #expect(coordinatorMock.navigationCallCount(to: .webview(url: expectedURL)) == 1)
    }
}
