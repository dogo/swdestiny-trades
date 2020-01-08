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
        let window = UIWindow.framed()

        describe("DeckGraphViewController layout") {

            context("when it's initialized") {

                beforeEach {
                    sut = DeckGraphViewController(deck: DeckDTO.stub())
                    window.showTestWindow(controller: sut)
                }

                afterEach {
                    window.cleanTestWindow()
                }

                xit("should have valid layout") {
                    expect(sut) == snapshot()
                }
            }
        }
    }
}
