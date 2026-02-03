//
//  NavigationCoordinator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
final class NavigationCoordinator: NavigationCoordinatorProtocol {

    @Published var path = NavigationPath()

    @Published var selectedTab: AppTab = .cards

    @Published var cardPath = NavigationPath()
    @Published var deckPath = NavigationPath()
    @Published var loanPath = NavigationPath()
    @Published var collectionPath = NavigationPath()

    func navigate(to destination: AppDestination) {
        switch selectedTab {
        case .cards:
            cardPath.append(destination)
        case .decks:
            deckPath.append(destination)
        case .loans:
            loanPath.append(destination)
        case .collection:
            collectionPath.append(destination)
        }
    }

    func navigate(to destination: AppDestination, on tab: AppTab) {
        selectedTab = tab

        Task {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            self.navigate(to: destination)
        }
    }

    func path(for tab: AppTab) -> Binding<NavigationPath> {
        switch tab {
        case .cards:
            return Binding(
                get: { self.cardPath },
                set: { self.cardPath = $0 }
            )
        case .decks:
            return Binding(
                get: { self.deckPath },
                set: { self.deckPath = $0 }
            )
        case .loans:
            return Binding(
                get: { self.loanPath },
                set: { self.loanPath = $0 }
            )
        case .collection:
            return Binding(
                get: { self.collectionPath },
                set: { self.collectionPath = $0 }
            )
        }
    }
}

enum AppTab: CaseIterable {
    case cards
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

struct NavigationCoordinatorKey: EnvironmentKey {
    @MainActor
    static let defaultValue = NavigationCoordinator()
}

extension EnvironmentValues {
    var navigationCoordinator: NavigationCoordinator {
        get { self[NavigationCoordinatorKey.self] }
        set { self[NavigationCoordinatorKey.self] = newValue }
    }
}
