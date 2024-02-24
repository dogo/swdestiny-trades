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

final class LoansDetailsPresenterSpy: LoansDetailsProtocol {

    private(set) var didCallStepperValueChangedValues: [(newValue: Int, card: CardDTO)] = []
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        didCallStepperValueChangedValues.append((newValue, card))
    }

    private(set) var didCallRemoveValues: [(section: AddCardType, index: Int)] = []
    func remove(from section: AddCardType, at index: Int) {
        didCallRemoveValues.append((section, index))
    }
}
