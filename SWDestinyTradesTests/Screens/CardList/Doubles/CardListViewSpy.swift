//
//  CardListViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class CardListViewSpy: UIView, CardListViewType {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

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
}
