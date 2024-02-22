//
//  DeckListViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 20/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckListViewType where Self: UIView {

    var didSelectDeck: ((DeckDTO) -> Void)? { get set }

    func updateTableViewData(decksList: [DeckDTO])
    func refreshData()
    func insert(deck: DeckDTO)
}
