//
//  SetsListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SWDestiny_Trades

class SetsListViewControllerTests: QuickSpec {

    override func spec() {

        var sut: SetsListViewController!
        var service: SWDestinyServiceImpl!
        var navigation: UINavigationController!
        let window = UIWindow.framed()

        describe("SetsListViewController layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized") {

                beforeEach {
                    service = SWDestinyServiceImpl(api: SWDestinyServiceMock())
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout") {
                    sut = SetsListViewController(service: service, database: nil)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)
                    expect(navigation) == snapshot()
                }
            }
        }
    }
}
