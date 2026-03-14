//
//  AboutViewSnapshotTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import XCTest

@testable import SWDestinyTrades

@MainActor
final class AboutViewSnapshotTests: XCSnapshotableTestCase {

    private var coordinator: NavigationCoordinator!

    override func setUp() {
        super.setUp()
        coordinator = NavigationCoordinator()
    }

    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }

    func testShouldHaveValidLayout() {
        let view = AboutView()
            .environment(coordinator)

        snapshot(view, size: .intrinsic, testMode: .validate)
    }
}
