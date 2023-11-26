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

@testable import PKHUD
@testable import SWDestinyTrades

final class AddCardViewControllerTests: QuickSpec {

    override class func spec() {

        describe("AddCardViewController") {

            var sut: AddCardViewController!
            var view: AddCardViewSpy!
            var database: DatabaseProtocol!
            var service: SWDestinyService!
            var keyWindow: UIWindow!

            beforeEach {
                keyWindow = UIWindow(frame: .testDevice)
                database = RealmDatabaseHelper.createMemoryDatabase(identifier: "UserCollection")
                service = SWDestinyService(client: HttpClientMock())
                view = AddCardViewSpy()
                sut = AddCardViewController(with: view,
                                            service: service,
                                            database: database,
                                            person: .stub(),
                                            userCollection: .stub(),
                                            type: .collection)
                let navigationController = UINavigationController(rootViewController: sut)
                keyWindow.showTestWindow(controller: navigationController)
            }

            afterEach {
                keyWindow.cleanTestWindow()
            }

            it("should create a controller") {
                expect(sut).toNot(beNil())
            }

            it("should have a view of type") {
                expect(sut.view).to(beAKindOf(AddCardViewType.self))
            }

            it("should have the expected navigation title") {
                sut.viewWillAppear(false)
                expect(sut.navigationItem.title).to(equal(L10n.addCard))
            }

            context("binding actions") {

                var collection: UserCollectionDTO!

                beforeEach {
                    collection = UserCollectionDTO.stub()
                }

                context("didSelectCard") {

                    it("should insert a card into the collection database successfully") {
                        sut = AddCardViewController(with: view,
                                                    service: service,
                                                    database: database,
                                                    person: .stub(),
                                                    userCollection: collection,
                                                    type: .collection)
                        let navigationController = UINavigationController(rootViewController: sut)
                        keyWindow.showTestWindow(controller: navigationController)

                        sut.viewDidLoad()
                        view.didSelectCard?(.stub())

                        expect(keyWindow.subviews.contains { $0 is ContainerView }).to(beTrue())
                    }

                    it("should not insert a card into the collection database") {
                        collection.addCard(.stub())

                        sut = AddCardViewController(with: view,
                                                    service: service,
                                                    database: database,
                                                    person: .stub(),
                                                    userCollection: collection,
                                                    type: .collection)
                        let navigationController = UINavigationController(rootViewController: sut)
                        keyWindow.showTestWindow(controller: navigationController)

                        sut.viewDidLoad()
                        view.didSelectCard?(.stub())

                        expect(keyWindow.subviews.contains { $0 is ContainerView }).to(beTrue())
                    }
                }

                it("didSelectAccessory") {
                    view.didSelectAccessory?(.stub())
                }

                it("doingSearch") {
                    view.doingSearch?("sss")
                }
            }
        }
    }
}
