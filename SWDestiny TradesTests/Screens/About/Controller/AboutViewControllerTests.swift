//
//  AboutViewControllerSpec.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import SafariServices
import UIKit

@testable import SWDestiny_Trades

final class AboutViewControllerTests: QuickSpec {

    override func spec() {

        describe("About view controller") {

            var sut: AboutViewController!

            beforeEach {
                sut = AboutViewController()
                let navigationController = UINavigationController(rootViewController: sut)
                let window = UIWindow.framed()
                window.showTestWindow(controller: navigationController)
            }

            it("should be able to create a controller") {
                expect(sut).toNot(beNil())
            }

            it("should have a view of type") {
                expect(sut.view).to(beAKindOf(AboutViewType.self))
            }

            it("should call didTouchHTTPLink when the url is touched") {

                let view = sut.view.viewWith(accessibilityIdentifier: "ABOUT_VIEW") as! AboutView
                view.didTouchHTTPLink?(URL(string: "http://google.com")!)
                expect(sut.presentedViewController).to(beAKindOf(SFSafariViewController.self))
            }

            it("should have the expected navigation title") {
                sut.viewWillAppear(true)

                expect(sut.navigationItem.title).to(equal(L10n.about))
            }
        }
    }
}
