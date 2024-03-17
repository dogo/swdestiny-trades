//
//  DeckBuilderPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckBuilderPresenterSpy: DeckBuilderProtocol, DeckBuilderPresenterProtocol {

    private(set) var didCallUpdateCardQuantity = [(newValue: Int, card: CardDTO)]()
    func updateCardQuantity(newValue: Int, card: CardDTO) {
        didCallUpdateCardQuantity.append((newValue, card))
    }

    private(set) var didCallUpdateCharacterElite = [(newValue: Bool, card: CardDTO)]()
    func updateCharacterElite(newValue: Bool, card: CardDTO) {
        didCallUpdateCharacterElite.append((newValue, card))
    }

    private(set) var didCallRemove = [Int]()
    func remove(at index: Int) {
        didCallRemove.append(index)
    }

    private(set) var didCallLoadData = [DeckDTO?]()
    func loadData(deck: DeckDTO?) {
        didCallLoadData.append(deck)
    }

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallSetupNavigationItemsCount = 0
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        didCallSetupNavigationItemsCount += 1
        completion([])
    }

    // swiftlint:disable:next identifier_name
    private(set) var didCallNavigateToCardDetailViewController = [(cardList: [CardDTO], card: CardDTO)]()
    func navigateToCardDetailViewController(cardList: [CardDTO], card: CardDTO) {
        didCallNavigateToCardDetailViewController.append((cardList, card))
    }
}
