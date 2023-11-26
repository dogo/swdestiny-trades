//
//  AboutViewControllerTests.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import SafariServices
import UIKit

@testable import SWDestinyTrades

final class AboutViewControllerTests: QuickSpec {

    override class func spec() {

        var window: UIWindow!

        describe("About view controller") {

            var sut: AboutViewController!
            var view: AboutViewSpy!

            beforeEach {
                window = UIWindow(frame: .testDevice)
                view = AboutViewSpy()
                sut = AboutViewController(with: view)
                let navigationController = UINavigationController(rootViewController: sut)
                window.showTestWindow(controller: navigationController)
            }

            it("should be able to create a controller") {
                expect(sut).toNot(beNil())
            }

            it("should have a view of type") {
                expect(sut.view).to(beAKindOf(AboutViewType.self))
            }

            it("should call didTouchHTTPLink when the url is touched") {
                sut.viewDidLoad()
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
