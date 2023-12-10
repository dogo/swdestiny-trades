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

        describe("SetsListPresenter") {

            context("when it's initialized") {

                beforeEach {
                    client = HttpClientMock()
                    service = SWDestinyService(client: client)
                    view = SetsListViewSpy()
                    navigator = SetsListNavigator(UIViewController())
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
                }

                it("aboutButtonTouched") {
                    sut.aboutButtonTouched()
                }

                it("searchButtonTouched") {
                    sut.searchButtonTouched()
                }
            }
        }
    }
}
