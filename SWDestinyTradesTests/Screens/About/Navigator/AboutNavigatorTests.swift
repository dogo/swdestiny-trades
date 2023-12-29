//
//  AboutNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import SafariServices
import XCTest

@testable import SWDestinyTrades

final class AboutNavigatorTests: XCTestCase {

    private var sut: AboutNavigator!
    private var controller: UIViewControllerMock!

    override func setUp() {
        super.setUp()
        controller = UIViewControllerMock()
        sut = AboutNavigator(controller)
    }

    override func tearDown() {
        controller = nil
        sut = nil
        super.tearDown()
    }

    func testNavigateToSFSafariViewController() {
        sut.navigate(to: .webview(url: URL(string: "http://google.com")!))

        XCTAssertTrue(controller.presentedViewController is SFSafariViewController)
    }
}
