//
//  NavigationCoordinator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class NavigationCoordinator: NavigationCoordinatorProtocol {

    var selectedTab: AppTab = .sets

    var setsPath = NavigationPath()
    var deckPath = NavigationPath()
    var loanPath = NavigationPath()
    var collectionPath = NavigationPath()

    // MARK: - Navigation

    func navigate(to destination: AppDestination) {
        navigate(to: destination, on: selectedTab)
    }

    func navigate(to destination: AppDestination, on tab: AppTab) {
        switch tab {
        case .sets:
            setsPath.append(destination)

        case .decks:
            deckPath.append(destination)

        case .loans:
            loanPath.append(destination)

        case .collection:
            collectionPath.append(destination)
        }
    }
}

enum AppTab: CaseIterable {
    case sets
    case decks
    case loans
    case collection
}

enum AppDestination: Hashable {
    case setsList
    case cardList(SetDTO)
    case cardDetail([CardDTO], CardDTO)
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

    case about
    case webview(url: URL)
}
