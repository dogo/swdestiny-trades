//
//  PeopleListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 19/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class PeopleListViewControllerTests: QuickSpec {

    override class func spec() {

        var sut: PeopleListViewController!
        var database: DatabaseProtocol!
        var navigation: UINavigationController!
        let window = UIWindow.framed()

        describe("PeopleListViewController layout") {

            beforeSuite {
                AppearanceProxyHelper.customizeNavigationBar()
            }

            context("when it's initialized from the tabbar") {

                beforeEach {
                    database = RealmDatabaseHelper.createMemoryDatabase(identifier: "PeopleList")
                }

                afterEach {
                    try! database.reset()
                    window.cleanTestWindow()
                }

                context("should have valid layout when trying to load a database") {

                    it("with empty state") {
                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)

                        expect(navigation).to(haveValidSnapshot(named: "PeopleListViewController with a empty state layout",
                                                                tolerance: 0.02))
                    }

                    it("with a person with no loans") {
                        let person = PersonDTO.stub()
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)

                        expect(navigation).to(haveValidSnapshot(named: "PeopleListViewController with a person with no loans",
                                                                tolerance: 0.02))
                    }

                    it("with a person with lent cards") {
                        let person = PersonDTO.stub()
                        person.lentMe.append(CardDTO.stub())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)

                        expect(navigation).to(haveValidSnapshot(named: "PeopleListViewController with a person with lent cards",
                                                                tolerance: 0.02))
                    }

                    it("with a person with borrowed cards") {
                        let person = PersonDTO.stub()
                        person.borrowed.append(CardDTO.stub())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)

                        expect(navigation).to(haveValidSnapshot(named: "PeopleListViewController with a person with borrowed cards",
                                                                tolerance: 0.02))
                    }

                    it("with a person with lent and borrowed cards") {
                        let person = PersonDTO.stub()
                        person.lentMe.append(CardDTO.stub())
                        person.borrowed.append(CardDTO.stub())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)

                        expect(navigation).to(haveValidSnapshot(named: "PeopleListViewController with a person with lent and borrowed cards",
                                                                tolerance: 0.02))
                    }
                }
            }
        }
    }
}
