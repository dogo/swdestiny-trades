//
//  AboutViewControllerTests.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import SafariServices
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AboutViewControllerTests: XCTestCase {

    private var window: UIWindow!
    private var sut: AboutViewController!
    private var view: AboutViewSpy!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: .testDevice)
        view = AboutViewSpy()
        sut = AboutViewController(with: view)
        let navigationController = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        window = nil
        sut = nil
        view = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut)
    }

    func testViewType() {
        XCTAssertTrue(sut.view is AboutViewType)
    }

    func testDidTouchHTTPLink() {
        sut.viewDidLoad()
        view.didTouchHTTPLink?(URL(string: "http://google.com")!)
        XCTAssertTrue(sut.presentedViewController is SFSafariViewController)
    }

    func testNavigationTitle() {
        sut.viewWillAppear(true)
        XCTAssertEqual(sut.navigationItem.title, L10n.about)
    }
}
