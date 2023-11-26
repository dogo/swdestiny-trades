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
import UIKit
import Nimble_Snapshots

@testable import SWDestinyTrades

final class AboutViewTests: QuickSpec {

    override class func spec() {

        var sut: AboutView!

        describe("AboutView layout") {

            context("when URL link it's touched") {

                beforeEach {
                    sut = AboutView(frame: .zero)
                    sut.translatesAutoresizingMaskIntoConstraints = false
                    sut.widthAnchor.constraint(equalToConstant: 320).isActive = true
                }
                
                it("should have valid layout") {
                    expect(sut) == snapshot("About View Controller")
                }

                it("should call closure when the url link is touched") {
                    var didTouchHTTPLinkWasCalled = false
                    var touchedURL: URL?

                    sut.didTouchHTTPLink = { url in
                        didTouchHTTPLinkWasCalled = true
                        touchedURL = url
                    }
                    let url = URL(string: "https://swdestinydb.com")!
                    let aboutTextView = sut.viewWith(accessibilityIdentifier: "ABOUT_TEXT_VIEW") as! UITextView
                    _ = aboutTextView.delegate?.textView?(aboutTextView,
                                                          shouldInteractWith: url,
                                                          in: NSRange(),
                                                          interaction: .invokeDefaultAction)
                    expect(didTouchHTTPLinkWasCalled) == true
                    expect(touchedURL) == url
                }
            }
        }
    }
}
