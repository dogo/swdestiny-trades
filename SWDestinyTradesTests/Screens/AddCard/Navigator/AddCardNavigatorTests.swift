//
//  AddCardNavigatorTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import Nimble
import Quick
import UIKit

@testable import SWDestinyTrades

final class AddCardNavigatorTests: QuickSpec {

    override func spec() {

        var sut: AddCardNavigator!
        var navigationController: UINavigationControllerMock!
        var panda: UIViewController!

        describe("AddCard screen navigation") {

            context("when navigate method is called with cardDetail destination") {

                beforeEach {
                    panda = UIViewController()
                    navigationController = UINavigationControllerMock(rootViewController: panda)
                    sut = AddCardNavigator(navigationController)
                }

                it("should to push to CardDetailViewController") {
                    sut.navigate(to: .cardDetail(database: nil,
                                                 with: [],
                                                 card: .stub()))
                    expect(navigationController.currentPushedViewController).to(beAKindOf(CardDetailViewController.self))
                }
            }
        }
    }
}
