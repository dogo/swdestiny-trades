//
//  AppDestination.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum AppDestination: Hashable {
    case setsList
    case cardList(SetDTO)
    case cardDetail([CardDTO], CardDTO, Bool = true)
    case search

    case deckList
    case deckBuilder(DeckDTO?)
    case deckGraph(DeckDTO)
    case addToDeck(DeckDTO)

    case peopleList
    case newPerson
    case loanDetail(String)

    case userCollection
    case addCard
    case addCardToCollection(UserCollectionDTO)
    case addCardToPerson(String, AddCardType)
    case scanCard

    case about
    case webview(url: URL)
}
