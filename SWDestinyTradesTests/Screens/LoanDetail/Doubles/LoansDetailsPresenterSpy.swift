//
//  LoansDetailsPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class LoansDetailsPresenterSpy: LoansDetailPresenterProtocol, LoansDetailsProtocol {

    private(set) var didCallLoadDataFromRealmCount = 0
    func loadDataFromRealm() {
        didCallLoadDataFromRealmCount += 1
    }
    
    private(set) var didCallSetNavigationTitleCount = 0
    func setNavigationTitle() {
        didCallSetNavigationTitleCount += 1
    }
    
    private(set) var didCallNavigateToCardDetailValues: [(card: CardDTO, destination: AddCardType)] = []
    func navigateToCardDetail(with card: CardDTO, destination: AddCardType) {
        didCallNavigateToCardDetailValues.append((card, destination))
    }
    
    private(set) var didCallNavigateToAddCardValues: [AddCardType] = []
    func navigateToAddCard(type: AddCardType) {
        didCallNavigateToAddCardValues.append(type)
    }

    private(set) var didCallStepperValueChangedValues: [(newValue: Int, card: CardDTO)] = []
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        didCallStepperValueChangedValues.append((newValue, card))
    }

    private(set) var didCallRemoveValues: [(section: AddCardType, index: Int)] = []
    func remove(from section: AddCardType, at index: Int) {
        didCallRemoveValues.append((section, index))
    }
}
