//
//  AboutViewSnapshotTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import Testing

@testable import SWDestinyTrades

@MainActor
final class AboutViewSnapshotTests: XCSnapshotableTestCase {

    @Test
    func testShouldHaveValidLayout() {
        let coordinator = NavigationCoordinator()
        let view = AboutView()
            .environment(coordinator)

        snapshot(view, size: .intrinsic, testMode: .validate)
    }
}
