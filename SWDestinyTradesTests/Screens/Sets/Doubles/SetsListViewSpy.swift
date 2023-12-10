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

    private(set) var didCallStartAnimating = 0
    func startAnimating() {
        didCallStartAnimating += 1
    }

    private(set) var didCallStopAnimating = 0
    func stopAnimating() {
        didCallStopAnimating += 1
    }

    private(set) var didCallEndRefreshControl = 0
    func endRefreshControl() {
        didCallEndRefreshControl += 1
    }

    private(set) var didCallUpdateSetList = [SetDTO]()
    func updateSetList(_ setList: [SetDTO]) {
        didCallUpdateSetList.append(contentsOf: setList)
    }

    private(set) var didCallSetupNavigationItem = 0
    func setupNavigationItem() {
        didCallSetupNavigationItem += 1
    }
}
