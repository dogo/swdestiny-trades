//
//  SetsListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListViewControllerTests: XCSnapshotableTestCase {

    private var sut: SetsListViewController!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var navigation: UINavigationController!
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        AppearanceProxyHelper.customizeNavigationBar()
        window = UIWindow(frame: .testDevice)
        client = HttpClientMock()
        client.fileName = "sets"
        service = SWDestinyService(client: client)
    }

    override func tearDown() {
        window.cleanTestWindow()
        super.tearDown()
    }

    func testValidLayout() {
        sut = SetsListViewController()
        let router = SetsListNavigator(sut)
        let presenter = SetsListPresenter(view: sut,
                                          interactor: SetsListInteractor(service: service),
                                          database: nil,
                                          navigator: router)
        sut.presenter = presenter

        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "SetsListViewControllerTests with a valid layout"))
    }
}
