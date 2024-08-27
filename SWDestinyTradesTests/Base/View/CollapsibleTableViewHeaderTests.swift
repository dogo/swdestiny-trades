//
//  CollapsibleTableViewHeaderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class CollapsibleTableViewHeaderTests: XCTestCase {

    func test_initialization() {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")

        XCTAssertNotNil(header)
        XCTAssertNotNil(header.titleLabel)
        XCTAssertNotNil(header.arrowLabel)
        XCTAssertEqual(header.section, 0)
        XCTAssertNil(header.delegate)
    }

    func test_height() {
        XCTAssertEqual(CollapsibleTableViewHeader.height(), 44)
    }

    func test_tap_header_calls_delegate() {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")
        let mockDelegate = CollapsibleTableViewHeaderDelegateMock()
        header.delegate = mockDelegate
        header.section = 1

        header.tapHeader(header.gestureRecognizers?[0] as! UITapGestureRecognizer)

        XCTAssertTrue(mockDelegate.toggleSectionCalled)
        XCTAssertEqual(mockDelegate.toggledSection, 1)
    }

    func test_tap_header_dont_calls_delegate() {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")
        let mockDelegate = CollapsibleTableViewHeaderDelegateMock()
        header.delegate = mockDelegate
        header.section = 1

        header.tapHeader(UITapGestureRecognizer())

        XCTAssertFalse(mockDelegate.toggleSectionCalled)
        XCTAssertNil(mockDelegate.toggledSection)
    }

    func test_set_collapsed_rotates_arrow_label() {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")

        header.setCollapsed(true)
        XCTAssertEqual(header.arrowLabel.transform.rotationAngle, 0.0, accuracy: 1e-10)

        header.setCollapsed(false)
        XCTAssertEqual(header.arrowLabel.transform.rotationAngle, CGFloat.pi / 2, accuracy: 1e-10)
    }
}

// MARK: - Mocks

private extension CGAffineTransform {
    var rotationAngle: CGFloat {
        return atan2(b, a)
    }
}

final class CollapsibleTableViewHeaderDelegateMock: CollapsibleTableViewHeaderDelegate {
    private(set) var toggleSectionCalled = false
    private(set) var toggledSection: Int?

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        toggleSectionCalled = true
        toggledSection = section
    }
}
