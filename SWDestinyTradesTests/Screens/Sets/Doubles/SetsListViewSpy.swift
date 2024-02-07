//
//  SetsListViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SetsListViewSpy: UIView, SetsListViewType {

    var didSelectSet: ((SetDTO) -> Void)?

    private(set) var didCallStartLoadingCount = 0
    func startLoading() {
        didCallStartLoadingCount += 1
    }

    private(set) var didCallStopLoadingCount = 0
    func stopLoading() {
        didCallStopLoadingCount += 1
    }

    private(set) var didCallEndRefreshControlCount = 0
    func endRefreshControl() {
        didCallEndRefreshControlCount += 1
    }

    private(set) var didCallUpdateSetList = [SetDTO]()
    func updateSetList(_ sets: [SetDTO]) {
        didCallUpdateSetList.append(contentsOf: sets)
    }

    private(set) var didCallSetupPullToRefresh = [(target: Any, action: Selector)]()
    func setupPullToRefresh(target: Any, action: Selector) {
        didCallSetupPullToRefresh.append((target, action))
    }
}
