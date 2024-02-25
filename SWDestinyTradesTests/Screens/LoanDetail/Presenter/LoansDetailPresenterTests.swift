//
//  LoansDetailPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class LoansDetailPresenterTests: XCTestCase {

    private var sut: LoansDetailPresenter!
    private var controller: LoansDetailViewControllerSpy!
    private var database: RealmDatabase?
    private var navigator: LoanDetailNavigator!
    private var navigationController: UINavigationControllerMock!
    private var person: PersonDTO!

    override func setUp() {
        super.setUp()
        person = .stub(lentMe: [.stub(), .stub()], borrowed: [.stub(), .stub()])
        controller = LoansDetailViewControllerSpy()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = LoanDetailNavigator(controller)
        sut = LoansDetailPresenter(controller: controller,
                                   database: database,
                                   person: person,
                                   navigator: navigator)
    }

    override func tearDown() {
        controller = nil
        database = nil
        navigator = nil
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Test loadDataFromRealm

    func test_loadDataFromRealm() {
        sut.loadDataFromRealm()

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateTableViewData[0])
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "User Mock")
    }

    // MARK: - Test navigateToCardDetail

    func test_navigateToCardDetailViewController_when_the_destination_is_borrow() {
        sut.navigateToCardDetail(with: .stub(), destination: .borrow)

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_navigateToCardDetailViewController_when_the_destination_is_lent() {
        sut.navigateToCardDetail(with: .stub(), destination: .lent)

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    // MARK: - Test navigateToAddCard

    func test_navigateToAddCard() {
        sut.navigateToAddCard(type: .borrow)

        XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }

    // MARK: - Test reloadTableView

    func test_reloadTableView() {

        let notification = Notification(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: ["personDTO": PersonDTO.stub()])

        NotificationCenter.default.post(notification)

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateTableViewData[0])
    }

    // MARK: - Test stepperValueChanged

    func test_stepperValueChanged() {
        let card: CardDTO = .stub()
        sut.stepperValueChanged(newValue: 4, card: card)

        XCTAssertEqual(card.quantity, 4)
    }

    // MARK: - Test remove

    func test_remove_from_borrow() {
        XCTAssertEqual(person.borrowed.count, 2)

        sut.remove(from: .borrow, at: 0)

        XCTAssertEqual(person.borrowed.count, 1)
    }

    func test_remove_from_lent() {
        XCTAssertEqual(person.lentMe.count, 2)

        sut.remove(from: .lent, at: 0)

        XCTAssertEqual(person.lentMe.count, 1)
    }

    func test_remove_from_another_case() {
        XCTAssertEqual(person.lentMe.count, 2)
        XCTAssertEqual(person.borrowed.count, 2)

        sut.remove(from: .collection, at: 0)

        XCTAssertEqual(person.lentMe.count, 2)
        XCTAssertEqual(person.borrowed.count, 2)
    }
}
