//
//  CardListPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class CardListPresenterSpy: CardListPresenterProtocol {

    private(set) var didCallRetrieveCardsListeCount = 0
    func retrieveCardsList() {
        didCallRetrieveCardsListeCount += 1
    }

    private(set) var didCallDidSelectCard = [(cardList: [CardDTO], card: CardDTO)]()
    func didSelectCard(cardList: [CardDTO], card: CardDTO) {
        didCallDidSelectCard.append((cardList, card))
    }

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }
}
