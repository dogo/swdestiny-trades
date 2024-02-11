//
//  DeckBuilderPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class DeckBuilderPresenterSpy: DeckBuilderProtocol {

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
}
