//
//  DeckGraphViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckGraphViewControllerTests: XCTestCase {

    private var sut: DeckGraphViewController!
    private var view: DeckGraphViewSpy!
    private var navigationController: UINavigationController!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = DeckGraphViewSpy()
        sut = DeckGraphViewController(with: view, deck: .stub())
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        view = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is DeckGraphViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(view.didCallUpdateCollecionViewData.count, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(sut.navigationItem.title, "Deck Statistics")
    }
}
