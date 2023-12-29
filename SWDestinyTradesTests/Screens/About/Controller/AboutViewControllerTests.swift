//
//  AboutViewControllerTests.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AboutViewControllerTests: XCTestCase {

    private var window: UIWindow!
    private var sut: AboutViewController!
    private var view: AboutViewSpy!
    private var presenter: AboutPresenterSpy!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: .testDevice)
        view = AboutViewSpy()
        presenter = AboutPresenterSpy()
        sut = AboutViewController(with: view)
        sut.presenter = presenter
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

        XCTAssertEqual(presenter.didCallDidTouchHTTPUrl.count, 1)
        XCTAssertEqual(presenter.didCallDidTouchHTTPUrl[0].absoluteString, "http://google.com")
    }

    func testNavigationTitle() {
        sut.viewWillAppear(false)
        XCTAssertEqual(sut.navigationItem.title, L10n.about)
    }
}
