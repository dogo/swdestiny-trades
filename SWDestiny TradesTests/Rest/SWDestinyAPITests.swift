//
//  SWDestinyAPITests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

class SWDestinyAPITests: QuickSpec {

    override func spec() {

        describe("SWDestinyAPI") {

            var sut: SWDestinyAPI!
            var session: URLSessionMock!

            beforeEach {
                session = URLSessionMock()
                sut = SWDestinyAPI(session: session)
            }

            it("instance") {
                expect(sut.session) === session
            }

            it("Retrieve set list with success") {

                let data: Data = JSONHelper.loadJSONData(withFile: "sets")!
                session.data = data

                waitUntil { done in
                    sut.retrieveSetList { result in
                        switch result {
                        case .success(let setList):
                            expect(setList).to(beAKindOf([SetDTO].self))
                            done()
                        case .failure(let error):
                            fail(error.localizedDescription)
                        }
                    }
                }
            }

            it("Retrieve card list with success") {

                let data: Data = JSONHelper.loadJSONData(withFile: "card-list")!
                session.data = data

                waitUntil { done in
                    sut.retrieveSetCardList(setCode: "anyString") { result in
                        switch result {
                        case .success(let cardList):
                            expect(cardList).to(beAKindOf([CardDTO].self))
                            done()
                        case .failure(let error):
                            fail(error.localizedDescription)
                        }
                    }
                }
            }

            it("Retrieve specific card with success") {

                let data: Data = JSONHelper.loadJSONData(withFile: "card")!
                session.data = data

                waitUntil { done in
                    sut.retrieveCard(cardId: "anyString") { result in
                        switch result {
                        case .success(let card):
                            expect(card).to(beAKindOf(CardDTO.self))
                            done()
                        case .failure(let error):
                            fail(error.localizedDescription)
                        }
                    }
                }
            }

            it("Retrieve all cards with success") {

                let data: Data = JSONHelper.loadJSONData(withFile: "card-list")!
                session.data = data

                waitUntil { done in
                    sut.retrieveAllCards { result in
                        switch result {
                        case .success(let cardList):
                            expect(cardList).to(beAKindOf([CardDTO].self))
                            done()
                        case .failure(let error):
                            fail(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
