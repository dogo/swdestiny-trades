//
//  UserCollectionPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class UserCollectionPresenterSpy: UserCollectionPresenterProtocol, UserCollectionProtocol {

    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }

    private(set) var didCallSetupNavigationItemsCount = 0
    func setupNavigationItems(completion: ([UIBarButtonItem]?, [UIBarButtonItem]?) -> Void) {
        didCallSetupNavigationItemsCount += 1
        completion([], [])
    }

    private(set) var didCallLoadDataFromRealmCount = 0
    func loadDataFromRealm() {
        didCallLoadDataFromRealmCount += 1
    }

    private(set) var didCallNavigateToCardDetail = [(cardList: [CardDTO], card: CardDTO)]()
    func navigateToCardDetail(cardList: [CardDTO], card: CardDTO) {
        didCallNavigateToCardDetail.append((cardList, card))
    }

    private(set) var didCallNavigateToAddCardCount = 0
    func navigateToAddCard() {
        didCallNavigateToAddCardCount += 1
    }

    private(set) var didCallStepperValueChanged = [(newValue: Int, card: CardDTO)]()
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        didCallStepperValueChanged.append((newValue: newValue, card: card))
    }

    private(set) var didCallRemoveAtIndex = [Int]()
    func remove(at index: Int) {
        didCallRemoveAtIndex.append(index)
    }
}
