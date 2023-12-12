//
//  AboutViewTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AboutViewTests: SnapshotableTestCase {

    var sut: AboutView!

    override func setUp() {
        super.setUp()
        sut = AboutView(frame: .zero)
        sut.translatesAutoresizingMaskIntoConstraints = false
        sut.widthAnchor.constraint(equalToConstant: 320).isActive = true
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAboutViewLayout() {
        XCTAssertTrue(snapshot(sut, named: "About View Controller"))
    }

    func testHTTPLinkTouchCallback() {
        // Arrange
        var didTouchHTTPLinkWasCalled = false
        var touchedURL: URL?

        sut.didTouchHTTPLink = { url in
            didTouchHTTPLinkWasCalled = true
            touchedURL = url
        }

        let url = URL(string: "https://swdestinydb.com")!
        let aboutTextView = sut.viewWith(accessibilityIdentifier: "ABOUT_TEXT_VIEW") as! UITextView

        // Act
        let result = aboutTextView.delegate?.textView?(aboutTextView,
                                                       shouldInteractWith: url,
                                                       in: NSRange(),
                                                       interaction: .invokeDefaultAction)

        // Assert
        XCTAssertTrue(didTouchHTTPLinkWasCalled)
        XCTAssertEqual(touchedURL, url)
        XCTAssertNotNil(result)
    }
}
