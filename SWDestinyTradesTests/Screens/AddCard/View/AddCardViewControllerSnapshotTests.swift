//
//  AddCardViewControllerSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class AddCardViewTests: QuickSpec {

    override class func spec() {

        var sut: AddCardViewController!
        var service: SWDestinyService!
        var navigation: UINavigationController!
        let window = UIWindow.framed()

        describe("AddCardViewController layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized from Loan screen") {

                beforeEach {
                    service = SWDestinyService(client: HttpClientMock())
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout when isLentMe is True") {
                    sut = AddCardViewController(service: service, database: nil, person: .stub(), type: .lent)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)

                    expect(navigation).to(haveValidSnapshot(named: "AddCardViewController layout when isLentMe is true",
                                                            tolerance: 0.02))
                }

                it("should have valid layout when isLentMe is false") {
                    sut = AddCardViewController(service: service, database: nil, person: .stub(), type: .borrow)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)

                    expect(navigation).to(haveValidSnapshot(named: "AddCardViewController layout when isLentMe is false",
                                                            tolerance: 0.02))
                }
            }
        }
    }
}
