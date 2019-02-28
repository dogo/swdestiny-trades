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
                sut.retrieveSetList { result in
                    switch result {
                    case .success(let setList):
                        expect(setList[0].name).to(equal("Awakenings"))
                        expect(setList[0].code).to(equal("AW"))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve card list with success") {
                sut.retrieveSetCardList(setCode: "anyString") { result in
                    switch result {
                    case .success(let cardList):
                        expect(cardList[0].setCode).to(equal("AW"))
                        expect(cardList[0].setName).to(equal("Awakenings"))
                        expect(cardList[0].typeCode).to(equal("character"))
                        expect(cardList[0].typeName).to(equal("Character"))
                        expect(cardList[0].factionCode).to(equal("red"))
                        expect(cardList[0].factionName).to(equal("Command"))
                        expect(cardList[0].affiliationCode).to(equal("villain"))
                        expect(cardList[0].affiliationName).to(equal("Villain"))
                        expect(cardList[0].rarityCode).to(equal("L"))
                        expect(cardList[0].rarityName).to(equal("Legendary"))
                        expect(cardList[0].position).to(equal(1))
                        expect(cardList[0].code).to(equal("01001"))
                        expect(cardList[0].ttscardid).to(equal("1300"))
                        expect(cardList[0].name).to(equal("Captain Phasma"))
                        expect(cardList[0].subtitle).to(equal("Elite Trooper"))
                        expect(cardList[0].cost).to(equal(0))
                        expect(cardList[0].health).to(equal(11))
                        expect(cardList[0].points).to(equal("12/15"))
                        expect(cardList[0].text).to(equal("Your non-unique characters have the Guardian keyword."))
                        expect(cardList[0].deckLimit).to(equal(1))
                        expect(cardList[0].flavor).to(equal("Whatever you're planning, it won't work."))
                        expect(cardList[0].illustrator).to(equal("Darren Tan"))
                        expect(cardList[0].isUnique).to(equal(true))
                        expect(cardList[0].hasDie).to(equal(true))
                        expect(cardList[0].externalUrl).to(equal("https://swdestinydb.com/card/01001"))
                        expect(cardList[0].imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))
                        expect(cardList[0].label).to(equal("Captain Phasma - Elite Trooper"))
                        expect(cardList[0].cp).to(equal(1215))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve specific card with success") {
                sut.retrieveCard(cardId: "anyString") { result in
                    switch result {
                    case .success(let card):
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
                        expect(card.flavor).to(equal("Whatever you're planning, it won't work."))
                        expect(card.illustrator).to(equal("Darren Tan"))
                        expect(card.isUnique).to(equal(true))
                        expect(card.hasDie).to(equal(true))
                        expect(card.externalUrl).to(equal("https://swdestinydb.com/card/01001"))
                        expect(card.imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))
                        expect(card.label).to(equal("Captain Phasma - Elite Trooper"))
                        expect(card.cp).to(equal(1215))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }

            it("Retrieve all cards with success") {
                sut.retrieveAllCards { result in
                    switch result {
                    case .success(let cardList):
                        expect(cardList[0].setCode).to(equal("AW"))
                        expect(cardList[0].setName).to(equal("Awakenings"))
                        expect(cardList[0].typeCode).to(equal("character"))
                        expect(cardList[0].typeName).to(equal("Character"))
                        expect(cardList[0].factionCode).to(equal("red"))
                        expect(cardList[0].factionName).to(equal("Command"))
                        expect(cardList[0].affiliationCode).to(equal("villain"))
                        expect(cardList[0].affiliationName).to(equal("Villain"))
                        expect(cardList[0].rarityCode).to(equal("L"))
                        expect(cardList[0].rarityName).to(equal("Legendary"))
                        expect(cardList[0].position).to(equal(1))
                        expect(cardList[0].code).to(equal("01001"))
                        expect(cardList[0].ttscardid).to(equal("1300"))
                        expect(cardList[0].name).to(equal("Captain Phasma"))
                        expect(cardList[0].subtitle).to(equal("Elite Trooper"))
                        expect(cardList[0].cost).to(equal(0))
                        expect(cardList[0].health).to(equal(11))
                        expect(cardList[0].points).to(equal("12/15"))
                        expect(cardList[0].text).to(equal("Your non-unique characters have the Guardian keyword."))
                        expect(cardList[0].deckLimit).to(equal(1))
                        expect(cardList[0].flavor).to(equal("Whatever you're planning, it won't work."))
                        expect(cardList[0].illustrator).to(equal("Darren Tan"))
                        expect(cardList[0].isUnique).to(equal(true))
                        expect(cardList[0].hasDie).to(equal(true))
                        expect(cardList[0].externalUrl).to(equal("https://swdestinydb.com/card/01001"))
                        expect(cardList[0].imageUrl).to(equal("https://swdestinydb.com/bundles/cards/en/01/01001.jpg"))
                        expect(cardList[0].label).to(equal("Captain Phasma - Elite Trooper"))
                        expect(cardList[0].cp).to(equal(1215))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
