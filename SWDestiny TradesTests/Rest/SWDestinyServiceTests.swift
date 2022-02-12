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

final class SWDestinyServiceTests: QuickSpec {

    override func spec() {
        describe("SWDestinyService") {
            var sut: SWDestinyService!
            var client: HttpClientMock!

            beforeEach {
                client = HttpClientMock()
                sut = SWDestinyService(client: client)
            }

            it("Retrieve set list with success") {
                client.fileName = "sets"
                sut.retrieveSetList { result in
                    switch result {
                    case let .success(setList):
                        expect(setList[0].name).to(equal("Awakenings"))
                        expect(setList[0].code).to(equal("AW"))
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve card list with success") {
                client.fileName = "card-list"
                sut.retrieveSetCardList(setCode: "anyString") { result in
                    switch result {
                    case let .success(cardList):
                        expect(cardList[0].setCode).to(equal("RIV"))
                        expect(cardList[0].setName).to(equal("Rivals"))
                        expect(cardList[0].typeCode).to(equal("character"))
                        expect(cardList[0].typeName).to(equal("Character"))
                        expect(cardList[0].factionCode).to(equal("blue"))
                        expect(cardList[0].factionName).to(equal("Force"))
                        expect(cardList[0].affiliationCode).to(equal("neutral"))
                        expect(cardList[0].affiliationName).to(equal("Neutral"))
                        expect(cardList[0].rarityCode).to(equal("S"))
                        expect(cardList[0].rarityName).to(equal("Starter"))
                        expect(cardList[0].position).to(equal(1))
                        expect(cardList[0].code).to(equal("06001"))
                        expect(cardList[0].ttscardid).to(equal("47000"))
                        expect(cardList[0].name).to(equal("Anakin Skywalker"))
                        expect(cardList[0].subtitle).to(equal("Conflicted Apprentice"))
                        expect(cardList[0].cost).to(equal(0))
                        expect(cardList[0].health).to(equal(10))
                        expect(cardList[0].points).to(equal("10/13"))
                        expect(cardList[0].text).to(equal("You cannot have Darth Vader on your team.\n[special] - Discard a hero card from your hand to give a character 2 shields or discard a villain card from your hand to deal 2 damage to a character."))
                        expect(cardList[0].deckLimit).to(equal(1))
                        expect(cardList[0].flavor).to(equal(""))
                        expect(cardList[0].illustrator).to(equal("Ryan Valle"))
                        expect(cardList[0].isUnique).to(equal(true))
                        expect(cardList[0].hasDie).to(equal(true))
                        expect(cardList[0].externalUrl).to(equal("https://swdestinydb.com/card/06001"))
                        expect(cardList[0].imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/06/06001.jpg"))
                        expect(cardList[0].label).to(equal("Anakin Skywalker - Conflicted Apprentice"))
                        expect(cardList[0].cp).to(equal(1013))
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve specific card with success") {
                client.fileName = "card"
                sut.retrieveCard(cardId: "anyString") { result in
                    switch result {
                    case let .success(card):
                        expect(card.setCode).to(equal("AW"))
                        expect(card.setName).to(equal("Awakenings"))
                        expect(card.typeCode).to(equal("character"))
                        expect(card.typeName).to(equal("Character"))
                        expect(card.factionCode).to(equal("red"))
                        expect(card.factionName).to(equal("Command"))
                        expect(card.affiliationCode).to(equal("villain"))
                        expect(card.affiliationName).to(equal("Villain"))
                        expect(card.rarityCode).to(equal("L"))
                        expect(card.rarityName).to(equal("Legendary"))
                        expect(card.position).to(equal(1))
                        expect(card.code).to(equal("01001"))
                        expect(card.ttscardid).to(equal("1300"))
                        expect(card.name).to(equal("Captain Phasma"))
                        expect(card.subtitle).to(equal("Elite Trooper"))
                        expect(card.cost).to(equal(0))
                        expect(card.health).to(equal(11))
                        expect(card.points).to(equal("12/15"))
                        expect(card.text).to(equal("Your non-unique characters have the Guardian keyword."))
                        expect(card.deckLimit).to(equal(1))
                        expect(card.flavor).to(equal("\"Whatever you\'re planning, it won\'t work.\""))
                        expect(card.illustrator).to(equal("Darren Tan"))
                        expect(card.isUnique).to(equal(true))
                        expect(card.hasDie).to(equal(true))
                        expect(card.externalUrl).to(equal("https://swdestinydb.com/card/01001"))
                        expect(card.imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))
                        expect(card.label).to(equal("Captain Phasma - Elite Trooper"))
                        expect(card.cp).to(equal(1215))
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve all cards with success") {
                client.fileName = "card-list"
                sut.retrieveAllCards { result in
                    switch result {
                    case let .success(cardList):
                        expect(cardList[0].setCode).to(equal("RIV"))
                        expect(cardList[0].setName).to(equal("Rivals"))
                        expect(cardList[0].typeCode).to(equal("character"))
                        expect(cardList[0].typeName).to(equal("Character"))
                        expect(cardList[0].factionCode).to(equal("blue"))
                        expect(cardList[0].factionName).to(equal("Force"))
                        expect(cardList[0].affiliationCode).to(equal("neutral"))
                        expect(cardList[0].affiliationName).to(equal("Neutral"))
                        expect(cardList[0].rarityCode).to(equal("S"))
                        expect(cardList[0].rarityName).to(equal("Starter"))
                        expect(cardList[0].position).to(equal(1))
                        expect(cardList[0].code).to(equal("06001"))
                        expect(cardList[0].ttscardid).to(equal("47000"))
                        expect(cardList[0].name).to(equal("Anakin Skywalker"))
                        expect(cardList[0].subtitle).to(equal("Conflicted Apprentice"))
                        expect(cardList[0].cost).to(equal(0))
                        expect(cardList[0].health).to(equal(10))
                        expect(cardList[0].points).to(equal("10/13"))
                        expect(cardList[0].text).to(equal("You cannot have Darth Vader on your team.\n[special] - Discard a hero card from your hand to give a character 2 shields or discard a villain card from your hand to deal 2 damage to a character."))
                        expect(cardList[0].deckLimit).to(equal(1))
                        expect(cardList[0].flavor).to(equal(""))
                        expect(cardList[0].illustrator).to(equal("Ryan Valle"))
                        expect(cardList[0].isUnique).to(equal(true))
                        expect(cardList[0].hasDie).to(equal(true))
                        expect(cardList[0].externalUrl).to(equal("https://swdestinydb.com/card/06001"))
                        expect(cardList[0].imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/06/06001.jpg"))
                        expect(cardList[0].label).to(equal("Anakin Skywalker - Conflicted Apprentice"))
                        expect(cardList[0].cp).to(equal(1013))
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("should cancel all requests") {
                sut.cancelAllRequests()
                expect(client.isCancelled) == true
            }
        }
    }
}
