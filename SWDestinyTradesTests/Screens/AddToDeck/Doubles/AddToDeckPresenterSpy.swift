//
//  AddToDeckPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AddToDeckPresenterSpy: AddToDeckPresenterProtocol {

    private(set) var didCallRetrieveAllCards = 0
    func retrieveAllCards() {
        didCallRetrieveAllCards += 1
    }

    private(set) var didCallInsertCard = [CardDTO]()
    func insert(card: CardDTO) {
        didCallInsertCard.append(card)
    }

    private(set) var didCallDoingSearch = [String]()
    func doingSearch(_ query: String) {
        didCallDoingSearch.append(query)
    }

    private(set) var didCallLoadDataFromRealm = 0
    func loadDataFromRealm() {
        didCallLoadDataFromRealm += 1
    }

    private(set) var didCallNavigateToCardDetail = [CardDTO]()
    func navigateToCardDetail(with card: CardDTO) {
        didCallNavigateToCardDetail.append(card)
    }
}
