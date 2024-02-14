//
//  AddCardViewSpy.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AddCardViewSpy: UIView, AddCardViewType, AddCardViewProtocol {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

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
    func showSuccessMessage(card: CardDTO, headUpDisplay: HeadUpDisplay?) {
        didCallShowSuccessMessage.append(card)
    }

    private(set) var didCallShowErrorMessage = 0
    func showErrorMessage() {
        didCallShowErrorMessage += 1
    }

    private(set) var didCallShowNetworkErrorMessage = 0
    func showNetworkErrorMessage() {
        didCallShowNetworkErrorMessage += 1
    }
}
