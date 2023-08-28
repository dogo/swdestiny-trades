//
//  LoanDetailNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/11/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import UIKit

@testable import SWDestinyTrades

final class LoanDetailNavigatorTests: QuickSpec {

    override class func spec() {

        describe("Loan Detail Navigator") {

            var sut: LoanDetailNavigator!
            var navigationController: UINavigationControllerMock!

            beforeEach {
                navigationController = UINavigationControllerMock()
                sut = LoanDetailNavigator(navigationController)
            }

            it("should navigate to CardDetailViewController") {
                sut.navigate(to: .cardDetail(database: nil, with: [.stub()], card: .stub()))

                expect(navigationController.currentPushedViewController).to(beAKindOf(CardDetailViewController.self))
            }

            it("should navigate to DeckBuilderViewController") {
                sut.navigate(to: .addCard(database: nil, with: .stub(), type: .borrow))

                expect(navigationController.currentPushedViewController).to(beAKindOf(AddCardViewController.self))
            }
        }
    }
}
