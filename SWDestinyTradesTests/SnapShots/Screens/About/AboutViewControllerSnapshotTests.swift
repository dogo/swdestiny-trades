//
//  AboutViewControllerSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class AboutViewControllerSnapshotTests: QuickSpec {

    override func spec() {

        var sut: AboutViewController!
        let window = UIWindow.framed()

        describe("AboutViewController layout") {

            context("when it's initialized") {

                beforeEach {
                    sut = AboutViewController()
                    window.showTestWindow(controller: sut)
                }

                afterEach {
                    window.cleanTestWindow()
                }

                it("should have valid layout") {
                    expect(sut) == snapshot("About View Controller")
                }
            }
        }
    }
}
