//
//  SWDestinyServiceImplTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

class SWDestinyServiceImplTests: QuickSpec {

    override func spec() {
        describe("About view controller") {

            var sut: SWDestinyServiceImpl!
            var api: SWDestinyServiceMock!

            beforeEach {
                api = SWDestinyServiceMock()
                sut = SWDestinyServiceImpl(api: api)
            }

            it("instance") {
                expect(sut.api) === api
            }
        }
    }
}
