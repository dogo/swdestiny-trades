//
//  SetsViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsViewTests: XCSnapshotableTestCase {

    private var sut: SetsView!

    override func setUp() {
        super.setUp()
        sut = SetsView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initialization() {
        let sets: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]
        sut.updateSetList(sets)

        XCTAssertTrue(snapshot(sut))
    }

    func test_didSelectSet() {
        var didCallDidSelectSet = [SetDTO]()
        sut.didSelectSet = { set in
            didCallDidSelectSet.append(set)
        }

        sut.setsTableView?.didSelectSet?(.stub())

        XCTAssertEqual(didCallDidSelectSet.count, 1)
        XCTAssertEqual(didCallDidSelectSet[0].name, SetDTO.stub().name)
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func test_beginRefreshing() {
        sut.beginRefreshing()

        XCTAssertFalse(sut.pullToRefresh.isRefreshing)
    }

    func test_endRefreshControl() {
        sut.endRefreshControl()

        XCTAssertNotNil(sut.pullToRefresh.attributedTitle)
        XCTAssertFalse(sut.pullToRefresh.isRefreshing)
    }

    func test_setupPullToRefresh() {
        let viewController = SetsListViewController(with: sut)

        let target = viewController
        let action = #selector(viewController.retrieveSets)

        sut.setupPullToRefresh(target: target, action: action)

        XCTAssertTrue(sut.pullToRefresh.allTargets.contains(target), "Target not added to pullToRefresh")
        let actions = sut.pullToRefresh.actions(forTarget: target, forControlEvent: .valueChanged)
        XCTAssertTrue(actions?.contains(action.description) ?? false, "Action not added to pullToRefresh")
    }
}
