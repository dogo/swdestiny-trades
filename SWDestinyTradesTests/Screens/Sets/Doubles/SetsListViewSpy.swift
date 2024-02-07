//
//  SetsListViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SetsListViewSpy: UIView, SetsListViewProtocol {

    private(set) var didCallStartAnimatingCount = 0
    func startLoading() {
        didCallStartAnimatingCount += 1
    }

    private(set) var didCallStopAnimatingCount = 0
    func stopLoading() {
        didCallStopAnimatingCount += 1
    }

    private(set) var didCallEndRefreshControlCount = 0
    func endRefreshControl() {
        didCallEndRefreshControlCount += 1
    }

    private(set) var didCallUpdateSetList = [SetDTO]()
    func updateSetList(_ setList: [SetDTO]) {
        didCallUpdateSetList.append(contentsOf: setList)
    }

    private(set) var didCallSetupNavigationItemCount = 0
    func setupNavigationItem() {
        didCallSetupNavigationItemCount += 1
    }

    private(set) var didCallShowNetworkErrorMessageCount = 0
    func showNetworkErrorMessage() {
        didCallShowNetworkErrorMessageCount += 1
    }
}
