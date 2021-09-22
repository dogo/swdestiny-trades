//
//  AboutViewControllerSpec.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import UIKit

@testable import SWDestiny_Trades

final class AboutViewControllerTests: QuickSpec {

    override func spec() {

        describe("About view controller") {

            var sut: AboutViewController!
            var view: AboutViewSpy!

            beforeEach {
                view = AboutViewSpy()
                sut = AboutViewController(with: view)
            }

            it("should be able to create a controller") {
                expect(sut).toNot(beNil())
            }

            it("should have a view of type") {
                expect(sut.view).to(beAKindOf(AboutViewType.self))
            }

            it("should call didTouchHTTPLink when the url is touched") {

                var didTouchHTTPLinkWasCalled = false
                var touchedURL: URL?

                view.didTouchHTTPLink = { url in
                    didTouchHTTPLinkWasCalled = true
                    touchedURL = url
                }

                _ = view.textView(UITextView(),
                                  shouldInteractWith: URL(string: "https://SWDestinyTrades.com")!,
                                  in: NSRange(),
                                  interaction: .invokeDefaultAction)
                expect(didTouchHTTPLinkWasCalled) == true
                expect(touchedURL) == URL(string: "https://SWDestinyTrades.com")!
            }

            it("should have the expected navigation title") {
                _ = UINavigationController(rootViewController: sut)
                sut.viewWillAppear(true)

                expect(sut.navigationItem.title).to(equal(L10n.about))
            }
        }
    }
}
