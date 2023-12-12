//
//  AddCardViewControllerSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardViewTests: XCSnapshotableTestCase {

    var sut: AddCardViewController!
    var service: SWDestinyService!
    var navigation: UINavigationController!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        AppearanceProxyHelper.customizeNavigationBar()
        window = UIWindow(frame: .testDevice)
        service = SWDestinyService(client: HttpClientMock())
    }

    override func tearDown() {
        window.cleanTestWindow()
        super.tearDown()
    }

    func testLayoutWhenIsLentMeIsTrue() {
        sut = AddCardViewController(service: service, database: nil, person: .stub(), type: .lent)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "AddCardViewController layout when isLentMe is true"))
    }

    func testLayoutWhenIsLentMeIsFalse() {
        sut = AddCardViewController(service: service, database: nil, person: .stub(), type: .borrow)
        navigation = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigation)

        XCTAssertTrue(snapshot(navigation, named: "AddCardViewController layout when isLentMe is false"))
    }
}
