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

    private(set) var didCallStartLoading = 0
    func startLoading() {
        didCallStartLoading += 1
    }

    private(set) var didCallStopLoading = 0
    func stopLoading() {
        didCallStopLoading += 1
    }

    private(set) var didCallUpdateCardList = [CardDTO]()
    func updateCardList(_ cards: [CardDTO]) {
        didCallUpdateCardList.append(contentsOf: cards)
    }

    private(set) var didCallShowNetworkErrorMessage = 0
    func showNetworkErrorMessage() {
        didCallShowNetworkErrorMessage += 1
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
