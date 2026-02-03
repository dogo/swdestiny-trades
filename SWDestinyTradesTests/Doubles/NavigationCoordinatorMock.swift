//
//  NavigationCoordinatorMock.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 02/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

@testable import SWDestinyTrades
import SwiftUI

@MainActor
final class NavigationCoordinatorMock: NavigationCoordinatorProtocol {

    struct NavigationCall: Equatable {
        let destination: AppDestination
        let timestamp: Date
        let tab: AppTab?

        init(destination: AppDestination, timestamp: Date, tab: AppTab? = nil) {
            self.destination = destination
            self.timestamp = timestamp
            self.tab = tab
        }
    }

    @Published var path = NavigationPath()
    @Published var selectedTab: AppTab = .cards
    @Published var cardPath = NavigationPath()
    @Published var deckPath = NavigationPath()
    @Published var loanPath = NavigationPath()
    @Published var collectionPath = NavigationPath()

    private(set) var navigationCalls: [NavigationCall] = []

    func navigate(to destination: AppDestination) {
        navigationCalls.append(NavigationCall(
            destination: destination,
            timestamp: Date(),
            tab: nil
        ))
    }

    func navigate(to destination: AppDestination, on tab: AppTab) {
        navigationCalls.append(NavigationCall(
            destination: destination,
            timestamp: Date(),
            tab: tab
        ))
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

    func didNavigate(to destination: AppDestination) -> Bool {
        navigationCalls.contains { $0.destination == destination }
    }

    func navigationCallCount(to destination: AppDestination) -> Int {
        navigationCalls.filter { $0.destination == destination }.count
    }

    func reset() {
        navigationCalls.removeAll()
    }
}
