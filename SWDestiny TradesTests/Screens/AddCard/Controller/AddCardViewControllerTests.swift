//
//  AddCardViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 14/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Nimble
import Quick
import UIKit

@testable import SWDestiny_Trades

final class AddCardViewControllerTests: QuickSpec {

    override func spec() {

        describe("AddCard view controller") {

            var sut: AddCardViewController!
            var view: AddCardViewSpy!

            beforeEach {
                view = AddCardViewSpy()
                sut = AddCardViewController(with: view,
                                            service: SWDestinyService(client: HttpClientMock()),
                                            database: nil,
                                            person: .stub(),
                                            userCollection: .stub(),
                                            type: .collection)
            }

            it("should be able to create a controller") {
                expect(sut).toNot(beNil())
            }

            it("should have a view of type") {
                expect(sut.view).to(beAKindOf(AddCardViewType.self))
            }

            it("should have the expected navigation title") {
                _ = UINavigationController(rootViewController: sut)
                sut.viewWillAppear(true)
                expect(sut.navigationItem.title).to(equal(L10n.addCard))
            }

            it("didSelectCard") {
                sut.viewDidLoad()
                view.didSelectCard?(.stub())
            }
        }
    }
}
