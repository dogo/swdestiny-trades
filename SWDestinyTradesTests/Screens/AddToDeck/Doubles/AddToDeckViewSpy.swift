//
//  AddToDeckViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AddToDeckViewSpy: UIView, AddToDeckViewType, AddToDeckViewProtocol {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?
    var didSelectRemote: (() -> Void)?
    var didSelectLocal: (() -> Void)?

    private(set) var didCallStartLoading = 0
    func startLoading() {
        didCallStartLoading += 1
    }

    private(set) var didCallStopLoading = 0
    func stopLoading() {
        didCallStopLoading += 1
    }

    private(set) var didCallUpdateSearchList = [CardDTO]()
    func updateSearchList(_ cards: [CardDTO]) {
        didCallUpdateSearchList.append(contentsOf: cards)
    }

    private(set) var didCallDoingSearch = [String]()
    func doingSearch(_ query: String) {
        didCallDoingSearch.append(query)
    }

    private(set) var didCallShowSuccessMessage = [CardDTO]()
    func showSuccessMessage(card: CardDTO) {
        didCallShowSuccessMessage.append(card)
    }
}
