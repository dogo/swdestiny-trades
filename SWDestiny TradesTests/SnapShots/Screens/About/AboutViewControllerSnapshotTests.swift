//
//  AboutViewControllerSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SWDestiny_Trades

class AboutViewControllerSnapshotTests: QuickSpec {

    override func spec() {

        var sut: AboutViewController!
        var window: UIWindow!

        describe("AboutViewController layout") {

            context("when it's initialized") {

                beforeEach {
                    sut = AboutViewController()
                    sut.view.backgroundColor = .white
                    window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 564))
                    window.rootViewController = sut
                    window.makeKeyAndVisible()
                }

                afterEach {
                    window.isHidden = true
                    window = nil
                }

                it("should have valid layout") {
                    expect(sut) == snapshot("About View Controller")
                }
            }
        }
    }
}
