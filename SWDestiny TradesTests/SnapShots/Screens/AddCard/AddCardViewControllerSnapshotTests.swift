//
//  AddCardViewControllerSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SWDestiny_Trades

class AddCardViewControllerSnapshotTests: QuickSpec {

    override func spec() {

        var sut: AddCardViewController!
        var service: SWDestinyServiceImpl!
        var navigation: UINavigationController!
        let window = UIWindow.framed()

        describe("AddCardViewController layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized from Loan screen") {

                beforeEach {
                    service = SWDestinyServiceImpl(api: SWDestinyServiceMock())
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout when isLentMe is True") {
                    sut = AddCardViewController(service: service, database: nil, person: PersonDTOMock.mockedPersonDTO(), type: .lent)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)
                    expect(navigation) == snapshot()
                }

                it("should have valid layout when isLentMe is false") {
                    sut = AddCardViewController(service: service, database: nil, person: PersonDTOMock.mockedPersonDTO(), type: .borrow)
                    navigation = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigation)
                    expect(navigation) == snapshot()
                }
            }
        }
    }
}
