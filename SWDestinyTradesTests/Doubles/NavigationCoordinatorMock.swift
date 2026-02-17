//
//  NavigationCoordinatorMock.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 02/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
@testable import SWDestinyTrades
import SwiftUI

@MainActor
@Observable
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

    var selectedTab: AppTab = .cards
    var cardPath = NavigationPath()
    var deckPath = NavigationPath()
    var loanPath = NavigationPath()
    var collectionPath = NavigationPath()

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
