//
//  AddCardViewControllerSpec.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 14/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

class AddCardViewControllerSpec: QuickSpec {

    override func spec() {
        describe("AddCard view controller") {

            var controller: AddCardViewController!

            beforeEach {
                controller = AddCardViewController()
            }

            it("should be able to create a controller") {
                expect(controller).toNot(beNil())
            }

            it("should have a view of type") {
                expect(controller.view).to(beAKindOf(AddCardView.self))
            }

            it("should have the expected navigation title") {
                _ = UINavigationController(rootViewController: controller)
                controller.viewWillAppear(true)
                expect(controller.navigationItem.title).to(equal(NSLocalizedString("ADD_CARD", comment: "")))
            }

            #if arch(x86_64) && os(iOS)
                it("should trigger fatal error if init with coder") {
                    expect { () -> Void in
                        _ = AddCardViewController(coder: NSCoder())
                        }.to(throwAssertion())
                }
            #endif
        }
    }
}
