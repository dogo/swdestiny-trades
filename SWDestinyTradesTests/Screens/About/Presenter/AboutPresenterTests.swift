//
//  AboutPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import SafariServices
import XCTest

@testable import SWDestinyTrades

final class AboutPresenterTests: XCTestCase {

    private var sut: AboutPresenter!
    private var navigator: AboutNavigator!
    private var controller: UIViewControllerMock!

    override func setUp() {
        super.setUp()
        controller = UIViewControllerMock()
        navigator = AboutNavigator(controller)
        sut = AboutPresenter(navigator: navigator)
    }

    override func tearDown() {
        controller = nil
        navigator = nil
        sut = nil
        super.tearDown()
    }

    func testDidTouchHTTPUrl() {
        sut.didTouchHTTPUrl(URL(string: "http://google.com")!)

        XCTAssertTrue(controller.presentedViewController is SFSafariViewController)
    }
}
