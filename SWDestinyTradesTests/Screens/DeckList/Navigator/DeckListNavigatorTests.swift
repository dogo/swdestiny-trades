//
//  DeckListNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/11/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import UIKit

@testable import SWDestinyTrades

final class DeckListNavigatorTests: QuickSpec {

    override func spec() {

        describe("Deck List Navigator") {

            var sut: DeckListNavigator!
            var navigationController: UINavigationControllerMock!

            beforeEach {
                navigationController = UINavigationControllerMock()
                sut = DeckListNavigator(navigationController)
            }

            it("should navigate to DeckBuilderViewController") {
                sut.navigate(to: .deckBuilder(database: nil, with: .stub()))

                expect(navigationController.currentPushedViewController).to(beAKindOf(DeckBuilderViewController.self))
            }
        }
    }
}
