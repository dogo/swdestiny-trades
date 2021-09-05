//
//  AboutViewTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SWDestiny_Trades

class AboutViewTests: QuickSpec {
    override func spec() {
        var sut: AboutView!

        describe("AboutView layout") {
            context("when URL link it's touched") {
                beforeEach {
                    sut = AboutView(frame: .zero)
                    sut.translatesAutoresizingMaskIntoConstraints = false
                    sut.widthAnchor.constraint(equalToConstant: 320).isActive = true
                }

                it("should call closure when the url link is touched") {
                    var touched = false
                    sut.didTouchHTTPLink = { _ in
                        touched = true
                    }
                    let url = URL(string: "https://swdestinydb.com")!
                    _ = sut.aboutTextView.delegate?.textView?(sut.aboutTextView, shouldInteractWith: url, in: NSRange(location: 0, length: 0), interaction: .invokeDefaultAction)

                    expect(touched) == true
                }
            }
        }
    }
}
