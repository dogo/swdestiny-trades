//
//  SetsListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class SetsListViewControllerTests: QuickSpec {

    override class func spec() {

        var sut: SetsListViewController!
        var service: SWDestinyService!
        var client: HttpClientMock!
        var navigation: UINavigationController!
        var window: UIWindow!

        describe("SetsListViewController layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized") {

                beforeEach {
                    window = UIWindow(frame: .testDevice)
                    client = HttpClientMock()
                    service = SWDestinyService(client: client)
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout") {
                    client.fileName = "sets"
                    sut = SetsListViewController(service: service, database: nil)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)

                    expect(navigation).to(haveValidSnapshot(named: "SetsListViewControllerTests with a valid layout",
                                                            tolerance: 0.02))
                }
            }
        }
    }
}
