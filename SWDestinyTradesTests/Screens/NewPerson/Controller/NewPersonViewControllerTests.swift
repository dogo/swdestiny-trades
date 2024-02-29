//
//  NewPersonViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class NewPersonViewControllerTests: XCTestCase {

    private var sut: NewPersonViewController!
    private var presenter: NewPersonPresenterSpy!
    private var navigationController: UINavigationControllerMock!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        presenter = NewPersonPresenterSpy()
        sut = NewPersonViewController()
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is NewPersonView)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle(L10n.newPerson)

        XCTAssertEqual(sut.navigationItem.title, "New Person")
    }

    func test_retriveUserInput() {
        let userInput = sut.retriveUserInput()

        XCTAssertEqual(userInput.name, "")
        XCTAssertEqual(userInput.lastName, "")
    }

    func test_closeViewController() {
        sut.closeViewController()

        XCTAssertEqual(navigationController.popViewControllerCount, 1)
    }
}
