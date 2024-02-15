//
//  CardListViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class CardListViewControllerSpy: UIViewController, CardListViewControllerProtocol {

    private(set) var didCallStartLoadingCount = 0
    func startLoading() {
        didCallStartLoadingCount += 1
    }

    private(set) var didCallStopLoadingCount = 0
    func stopLoading() {
        didCallStopLoadingCount += 1
    }

    private(set) var didCallUpdateCardList = [CardDTO]()
    func updateCardList(_ cards: [CardDTO]) {
        didCallUpdateCardList.append(contentsOf: cards)
    }

    private(set) var didCallShowNetworkErrorMessageCount = 0
    func showNetworkErrorMessage() {
        didCallShowNetworkErrorMessageCount += 1
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
