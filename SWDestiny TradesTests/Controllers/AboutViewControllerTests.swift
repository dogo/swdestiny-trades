//
//  AboutViewControllerSpec.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

class AboutViewControllerTests: QuickSpec {

    override func spec() {
        describe("About view controller") {

            var controller: AboutViewController!

            beforeEach {
                controller = AboutViewController()
            }

            it("should be able to create a controller") {
                expect(controller).toNot(beNil())
            }

            it("should have a view of type") {
                expect(controller.view).to(beAKindOf(AboutView.self))
            }

            it("should have the expected navigation title") {
                _ = UINavigationController(rootViewController: controller)
                controller.viewWillAppear(true)
                expect(controller.navigationItem.title).to(equal(L10n.about))
            }

#if arch(x86_64) && os(iOS)
            it("should trigger fatal error if init with coder") {
                expect { () -> Void in
                    _ = AboutViewController(coder: NSCoder())
                }.to(throwAssertion())
            }
#endif
        }
    }
}
