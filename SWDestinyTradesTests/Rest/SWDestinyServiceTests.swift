//
//  SWDestinyServiceTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick

@testable import SWDestinyTrades

final class SWDestinyServiceTests: AsyncSpec {

    override class func spec() {

        describe("SWDestinyService") {

            var sut: SWDestinyService!
            var client: HttpClientMock!

            beforeEach {
                client = HttpClientMock()
                sut = SWDestinyService(client: client)
            }

            it("Retrieve set list with success") {
                client.fileName = "sets"

                await expect { try? await sut.retrieveSetList() }.toNot(beNil())
            }

            it("Retrieve card list with success") {
                client.fileName = "card-list"

                await expect { try? await sut.retrieveSetCardList(setCode: "anyString") }.toNot(beNil())
            }

            it("Retrieve specific card with success") {
                client.fileName = "card"

                await expect { try? await sut.retrieveCard(cardId: "anyString") }.toNot(beNil())
            }

            it("Retrieve all cards with success") {
                client.fileName = "card-list"

                await expect { try? await sut.retrieveAllCards() }.toNot(beNil())
            }

            it("should cancel all requests") {
                sut.cancelAllRequests()

                expect(client.isCancelled) == true
            }
        }
    }
}
