//
//  SetsListViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SetsListViewControllerSpy: UIViewController, SetsListViewControllerProtocol {

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
