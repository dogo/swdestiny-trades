//
//  NavigationCoordinator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

@MainActor
final class NavigationCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    @Published var selectedTab: AppTab = .cards

    @Published var cardPath = NavigationPath()
    @Published var deckPath = NavigationPath()
    @Published var loanPath = NavigationPath()
    @Published var collectionPath = NavigationPath()

    @Published var navigationError: NavigationError?

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

    func pop() {
        switch selectedTab {
        case .cards:
            if !cardPath.isEmpty {
                cardPath.removeLast()
            }
        case .decks:
            if !deckPath.isEmpty {
                deckPath.removeLast()
            }
        case .loans:
            if !loanPath.isEmpty {
                loanPath.removeLast()
            }
        case .collection:
            if !collectionPath.isEmpty {
                collectionPath.removeLast()
            }
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .cards:
            cardPath = NavigationPath()
        case .decks:
            deckPath = NavigationPath()
        case .loans:
            loanPath = NavigationPath()
        case .collection:
            collectionPath = NavigationPath()
        }
    }

    func popToRoot(for tab: AppTab) {
        switch tab {
        case .cards:
            cardPath = NavigationPath()
        case .decks:
            deckPath = NavigationPath()
        case .loans:
            loanPath = NavigationPath()
        case .collection:
            collectionPath = NavigationPath()
        }
    }

    var currentPath: Binding<NavigationPath> {
        switch selectedTab {
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

    func clearError() {
        navigationError = nil
    }
}

enum AppTab: String, CaseIterable {
    case cards = "Cards"
    case decks = "Decks"
    case loans = "Loans"
    case collection = "Collection"

    var title: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .cards:
            return "ic_cards"
        case .decks:
            return "ic_decks"
        case .loans:
            return "ic_loans"
        case .collection:
            return "ic_collection"
        }
    }

    var selectedIcon: String {
        switch self {
        case .cards:
            return "ic_cards_filled"
        case .decks:
            return "ic_decks"
        case .loans:
            return "ic_loans"
        case .collection:
            return "ic_collection"
        }
    }
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

    var title: String {
        switch self {
        case .setsList:
            return "Sets"
        case .cardList:
            return "Cards"
        case .cardDetail:
            return "Card Detail"
        case .search:
            return "Search"
        case .deckList:
            return "Decks"
        case let .deckBuilder(deck):
            return deck == nil ? "New Deck" : "Edit Deck"
        case .deckGraph:
            return "Deck Graph"
        case .addToDeck:
            return "Add to Deck"
        case .peopleList:
            return "People"
        case .newPerson:
            return "New Person"
        case .loanDetail:
            return "Loan Details"
        case .userCollection:
            return "My Collection"
        case .addCard:
            return "Add Card"
        case .addCardToCollection:
            return "Add to Collection"
        case .addCardToPerson:
            return "Add Card"
        case .about:
            return "About"
        case .webview:
            return "Web"
        }
    }
}

enum NavigationError: Error, LocalizedError {
    case navigationFailed(String)
    case destinationNotFound(String)
    case invalidParameters

    var errorDescription: String? {
        switch self {
        case let .navigationFailed(message):
            return "Navigation failed: \(message)"
        case let .destinationNotFound(destination):
            return "Destination not found: \(destination)"
        case .invalidParameters:
            return "Invalid parameters provided for navigation"
        }
    }
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

@MainActor
class HybridNavigationManager: ObservableObject {

    weak var uikitNavigationController: UINavigationController?

    let swiftUICoordinator = NavigationCoordinator()

    @Published var navigationMode: NavigationMode = .swiftUI

    init(uikitNavigationController: UINavigationController? = nil) {
        self.uikitNavigationController = uikitNavigationController
    }

    func navigate(to destination: AppDestination) {
        switch navigationMode {
        case .swiftUI:
            swiftUICoordinator.navigate(to: destination)
        case .uikit:
            navigateUIKit(to: destination)
        case .hybrid:
            if shouldUseSwiftUI(for: destination) {
                swiftUICoordinator.navigate(to: destination)
            } else {
                navigateUIKit(to: destination)
            }
        }
    }

    private func navigateUIKit(to destination: AppDestination) {
        guard let navigationController = uikitNavigationController else {
            swiftUICoordinator.navigationError = NavigationError.navigationFailed("UIKit navigation controller not available")
            return
        }

        let viewController = createUIKitViewController(for: destination)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func createUIKitViewController(for destination: AppDestination) -> UIViewController {
        let placeholder = UIViewController()
        placeholder.title = destination.title
        placeholder.view.backgroundColor = .systemBackground
        return placeholder
    }

    private func shouldUseSwiftUI(for destination: AppDestination) -> Bool {
        switch destination {
        case .setsList, .cardList, .search:
            return true
        default:
            return false
        }
    }
}

enum NavigationMode {
    case swiftUI
    case uikit
    case hybrid
}
