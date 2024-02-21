//
//  DeckListViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DeckListViewControllerProtocol: AnyObject {
    func updateTableViewData(deckList: [DeckDTO])
    func insert(deck: DeckDTO)
    func setNavigationTitle(_ title: String)
}
