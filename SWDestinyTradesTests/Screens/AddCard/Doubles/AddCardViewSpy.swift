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

final class AddCardViewSpy: UIView, AddCardViewType {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    private(set) var startLoadingWasCalled = false
    func startLoading() {
        startLoadingWasCalled = true
    }

    private(set) var stopLoadingWasCalled = false
    func stopLoading() {
        stopLoadingWasCalled = true
    }

    private(set) var updateSearchListWasCalled = false
    func updateSearchList(_ cards: [CardDTO]) {
        updateSearchListWasCalled = true
    }

    private(set) var doingSearchWasCalled = false
    func doingSearch(_ query: String) {
        doingSearchWasCalled = true
    }
}
