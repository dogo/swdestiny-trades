//
//  SearchListViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SearchListViewControllerSpy: UIViewController, SearchListViewControllerProtocol {

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }

    private(set) var didCallStartLoadingCount = 0
    func startLoading() {
        didCallStartLoadingCount += 1
    }

    private(set) var didCallStopLoadingCount = 0
    func stopLoading() {
        didCallStopLoadingCount += 1
    }

    private(set) var didCallUpdateTableViewData = [CardDTO]()
    func updateTableViewData(_ cardList: [CardDTO]) {
        didCallUpdateTableViewData.append(contentsOf: cardList)
    }

    private(set) var didCallShowNetworkErrorMessageCount = 0
    func showNetworkErrorMessage() {
        didCallShowNetworkErrorMessageCount += 1
    }
}
