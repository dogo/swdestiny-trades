//
//  SetsListNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import UIKit

@testable import SWDestinyTrades

final class SetsListNavigatorTests: QuickSpec {

    override class func spec() {

        describe("SetsListNavigator") {

            var sut: SetsListNavigator!
            var navigationController: UINavigationControllerMock!

            beforeEach {
                let controller = UIViewController()
                navigationController = UINavigationControllerMock(rootViewController: controller)
                sut = SetsListNavigator(controller)
            }

            it("should navigate to AboutViewController") {
                sut.navigate(to: .about)

                expect(navigationController.currentPushedViewController).to(beAKindOf(AboutViewController.self))
            }

            it("should navigate to CardListViewController") {
                sut.navigate(to: .cardList(database: nil, with: .stub()[0]))

                expect(navigationController.currentPushedViewController).to(beAKindOf(CardListViewController.self))
            }

            it("should navigate to SearchListViewController") {
                sut.navigate(to: .search(database: nil))

                expect(navigationController.currentPushedViewController).to(beAKindOf(SearchListViewController.self))
            }
        }
    }
}
