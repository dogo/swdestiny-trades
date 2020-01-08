//
//  PeopleListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 19/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import SWDestiny_Trades

class PeopleListViewControllerTests: QuickSpec {

    override func spec() {

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
                    try! database = RealmDatabase(configuration: .inMemory(identifier: self.name))
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
                        expect(navigation) == snapshot()
                    }

                    it("with a person with no loans") {
                        let person = PersonDTOMock.mockedPersonDTO()
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)
                        expect(navigation) == snapshot()
                    }

                    it("with a person with lent cards") {
                        let person = PersonDTOMock.mockedPersonDTO()
                        person.lentMe.append(CardDTOMock.mockedCardDTO())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)
                        expect(navigation) == snapshot()
                    }

                    it("with a person with borrowed cards") {
                        let person = PersonDTOMock.mockedPersonDTO()
                        person.borrowed.append(CardDTOMock.mockedCardDTO())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)
                        expect(navigation) == snapshot()
                    }

                    it("with a person with lent and borrowed cards") {
                        let person = PersonDTOMock.mockedPersonDTO()
                        person.lentMe.append(CardDTOMock.mockedCardDTO())
                        person.borrowed.append(CardDTOMock.mockedCardDTO())
                        try! database.save(object: person)

                        sut = PeopleListViewController(database: database)
                        navigation = UINavigationController(rootViewController: sut)
                        window.showTestWindow(controller: navigation)
                        expect(navigation) == snapshot()
                    }
                }
            }
        }
    }
}