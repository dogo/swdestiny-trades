//
//  SearchViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 19/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class SearchViewSpy: UIView, SearchViewType {

    var didSelectCard: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    private(set) var didCallStartLoadingCount = 0
    func startLoading() {
        didCallStartLoadingCount += 1
    }

    private(set) var didCallStopLoadingCount = 0
    func stopLoading() {
        didCallStopLoadingCount += 1
    }

    private(set) var didCallUpdateSearchListValues = [CardDTO]()
    func updateSearchList(_ cards: [CardDTO]) {
        didCallUpdateSearchListValues.append(contentsOf: cards)
    }
}
