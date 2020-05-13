//
//  DeckGraphViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SWDestiny_Trades

class DeckGraphViewControllerTests: QuickSpec {

    override func spec() {

        var sut: DeckGraphViewController!
        var navigationController: UINavigationController!
        let window = UIWindow.framed(frame: CGRect(x: 0, y: 0, width: 375, height: 1350))

        describe("DeckGraphViewController layout") {

            context("when it's initialized") {

                beforeEach {
                    let deck = DeckDTO.stub()
                    let memoryDB = RealmDatabaseHelper.createMemoryDatabase(identifier: "DeckGraph")
                    try? memoryDB?.save(object: deck)

                    sut = DeckGraphViewController(deck: deck)
                    navigationController = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigationController)
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout") {
                    expect(navigationController).to(haveValidSnapshot(tolerance: 0.02))
                }

                it("should have an empty state layout") {
                    let deck = DeckDTO.stub(emptyList: true)
                    sut = DeckGraphViewController(deck: deck)
                    navigationController = UINavigationController(rootViewController: sut)
                    window.showTestWindow(controller: navigationController)

                    expect(navigationController).to(haveValidSnapshot(tolerance: 0.02))
                }
            }
        }
    }
}
