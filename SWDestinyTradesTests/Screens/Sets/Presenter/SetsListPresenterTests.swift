//
//  SetsListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class SetsListPresenterTests: QuickSpec {

    override class func spec() {

        var sut: SetsListPresenter!
        var service: SWDestinyService!
        var client: HttpClientMock!
        var view: SetsListViewSpy!
        var navigator: SetsListNavigator!
        var navigationController: UINavigationControllerMock!

        describe("SetsListPresenter") {

            context("when it's initialized") {

                beforeEach {
                    let controller = UIViewController()
                    client = HttpClientMock()
                    service = SWDestinyService(client: client)
                    navigationController = UINavigationControllerMock(rootViewController: controller)
                    view = SetsListViewSpy()
                    navigator = SetsListNavigator(controller)
                    sut = SetsListPresenter(view: view,
                                            interactor: SetsListInteractor(service: service),
                                            database: nil,
                                            navigator: navigator)
                }

                it("viewDidLoad") {
                    sut.viewDidLoad()

                    expect(view.didCallStartAnimating) == 1
                    expect(view.didCallSetupNavigationItem) == 1
                }

                it("didSelectSet") {
                    sut.didSelectSet(.stub()[0])

                    expect(navigationController.currentPushedViewController).to(beAKindOf(CardListViewController.self))
                }

                it("aboutButtonTouched") {
                    sut.aboutButtonTouched()

                    expect(navigationController.currentPushedViewController).to(beAKindOf(AboutViewController.self))
                }

                it("searchButtonTouched") {
                    sut.searchButtonTouched()

                    expect(navigationController.currentPushedViewController).to(beAKindOf(SearchListViewController.self))
                }
            }
        }
    }
}
