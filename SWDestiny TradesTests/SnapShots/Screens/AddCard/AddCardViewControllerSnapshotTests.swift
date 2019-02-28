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
        let window = UIWindow.framed()

        describe("AddCardViewController layout") {

            context("when it's initialized from Loan screen") {

                beforeEach {
                    service = SWDestinyServiceImpl(api: SWDestinyServiceMock())
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout when isLentMe is True") {
                    sut = AddCardViewController(service: service, person: PersonDTOMock.mockedPersonDTO(), type: .lent)
                    window.showTestWindow(controller: sut)
                    expect(sut) == snapshot()
                }

                it("should have valid layout when isLentMe is false") {
                    sut = AddCardViewController(service: service, person: PersonDTOMock.mockedPersonDTO(), type: .borrow)
                    window.showTestWindow(controller: sut)
                    expect(sut) == snapshot()
                }
            }
        }
    }
}
