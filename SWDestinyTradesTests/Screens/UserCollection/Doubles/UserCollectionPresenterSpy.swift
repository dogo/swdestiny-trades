//
//  UserCollectionPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class UserCollectionPresenterSpy: UserCollectionProtocol {

    private(set) var didCallStepperValueChanged = [(newValue: Int, card: CardDTO)]()
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        didCallStepperValueChanged.append((newValue: newValue, card: card))
    }

    private(set) var didCallRemoveAtIndex = [Int]()
    func remove(at index: Int) {
        didCallRemoveAtIndex.append(index)
    }
}
