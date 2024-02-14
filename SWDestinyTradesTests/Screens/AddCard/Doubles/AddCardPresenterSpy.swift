//
//  AddCardPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AddCardPresenterSpy: AddCardPresenterProtocol {

    private(set) var didCallFetchAllCards = 0
    func fetchAllCards() {
        didCallFetchAllCards += 1
    }

    private(set) var didCallInsert = [CardDTO]()
    func insert(card: CardDTO) {
        didCallInsert.append(card)
    }

    private(set) var didCallDoingSearch = [String]()
    func doingSearch(_ query: String) {
        didCallDoingSearch.append(query)
    }

    private(set) var didCallDidCardDetailButtonTouched = [CardDTO]()
    func cardDetailButtonTouched(with card: CardDTO) {
        didCallDidCardDetailButtonTouched.append(card)
    }
}
