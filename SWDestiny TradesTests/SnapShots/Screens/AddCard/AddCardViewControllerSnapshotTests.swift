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
        var window: UIWindow!

        describe("AddCardViewController layout") {

            context("when it's initialized from Loan screen") {

                beforeEach {
                    service = SWDestinyServiceImpl(api: SWDestinyServiceMock())
                    window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 564))
                    window.makeKeyAndVisible()
                }

                afterEach {
                    window.isHidden = true
                    window = nil
                }

                it("should have valid layout when isLentMe is True") {
                    sut = AddCardViewController(service: service, person: PersonDTOMock.mockedPersonDTO(), isLentMe: true)
                    window.rootViewController = sut
                    expect(sut) == snapshot()
                }

                it("should have valid layout when isLentMe is false") {
                    sut = AddCardViewController(service: service, person: PersonDTOMock.mockedPersonDTO(), isLentMe: false)
                    window.rootViewController = sut
                    expect(sut) == snapshot()
                }
            }
        }
    }
}
