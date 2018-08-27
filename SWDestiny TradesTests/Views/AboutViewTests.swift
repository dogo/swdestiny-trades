//
//  AboutViewTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
//import Nimble_Snapshots

@testable import SWDestiny_Trades

class AboutViewTests: QuickSpec {

    override func spec() {

        var sut: AboutView!
        var window: UIWindow!

        describe("AboutView layout") {

            beforeSuite {
                window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 564))
                window.makeKeyAndVisible()
            }

            afterSuite {
                window.isHidden = true
                window = nil
            }

            context("when URL link it's touched") {

                beforeEach {
                    sut = AboutView(frame: .zero)
                    sut.frame = window.frame
                }

                it("should call closure when the url link is touched") {

                    var touched = false
                    sut.didTouchHTTPLink = { url in
                        touched = true
                    }

                    //sut.addButton.sendActions(for: .touchUpInside)

                    expect(touched) == true
                }
            }
        }
    }
}
