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
        
        describe("SWDestinyServiceImpl") {

            var sut: SWDestinyServiceImpl!
            var api: SWDestinyServiceMock!

            beforeEach {
                api = SWDestinyServiceMock()
                sut = SWDestinyServiceImpl(api: api)
            }

            it("instance") {
                expect(sut.api) === api
            }
            
            it("Retrieve set list with success") {
                sut.retrieveSetList(completion: { result in
                    switch result {
                    case .success(let setList):
                        expect(setList[0].name).to(equal("Awakenings"))
                        expect(setList[0].code).to(equal("AW"))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                })
            }
        }
    }
}
