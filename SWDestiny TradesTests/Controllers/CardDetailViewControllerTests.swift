//
//  CardDetailViewControllerSpec.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 25/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

class CardDetailViewControllerTests: QuickSpec {

    override func spec() {
        describe("CardDetail view controller") {

            var controller: CardDetailViewController!
            let cardList = [CardDTO()]

            beforeEach {
                controller = CardDetailViewController(cardList: cardList, selected: CardDTO())
            }

            it("should be able to create a controller") {
                expect(controller).toNot(beNil())
            }

            it("should have a view of type") {
                expect(controller.view).to(beAKindOf(CardView.self))
            }

            it("should have the expected navigation title") {
                _ = UINavigationController(rootViewController: controller)
                controller.viewWillAppear(true)
                expect(controller.navigationItem.title).to(equal(NSLocalizedString("", comment: "")))
            }
        }
    }
}
