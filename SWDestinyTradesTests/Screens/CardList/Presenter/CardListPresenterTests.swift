//
//  CardListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardListPresenterTests: XCTestCase {

    private var sut: CardListPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var navigator: CardListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        client = HttpClientMock()
        client.fileName = "card-list"
        service = SWDestinyService(client: client)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = CardListNavigator(controller.navigationController)
        sut = CardListPresenter(interactor: CardListInteractor(service: service),
                                database: nil,
                                navigator: navigator,
                                setDTO: .stub())
    }

    override func tearDown() {
        client = nil
        service = nil
        navigationController = nil
        navigator = nil
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // sut.viewDidLoad()
    }

    func testDidSelectSet() {
        sut.didSelectCard(cardList: [], card: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }
}
