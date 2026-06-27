//
//  NavigationCoordinatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class NavigationCoordinatorTests {

    private var sut: NavigationCoordinator!

    init() {
        sut = NavigationCoordinator()
    }

    deinit {
        sut = nil
    }

    @Test
    func test_initialState_selectsSetsTabWithEmptyPaths() {
        #expect(sut.selectedTab == .sets)
        #expect(sut.setsPath.isEmpty)
        #expect(sut.deckPath.isEmpty)
        #expect(sut.loanPath.isEmpty)
        #expect(sut.collectionPath.isEmpty)
    }

    @Test
    func test_navigate_withoutTab_usesSelectedTab() {
        sut.selectedTab = .decks

        sut.navigate(to: .search)

        #expect(sut.setsPath.isEmpty)
        #expect(sut.deckPath.count == 1)
        #expect(sut.loanPath.isEmpty)
        #expect(sut.collectionPath.isEmpty)
    }

    @Test
    func test_navigate_onSpecificTab_doesNotChangeSelectedTab() {
        sut.selectedTab = .sets

        sut.navigate(to: .peopleList, on: .loans)

        #expect(sut.selectedTab == .sets)
        #expect(sut.setsPath.isEmpty)
        #expect(sut.deckPath.isEmpty)
        #expect(sut.loanPath.count == 1)
        #expect(sut.collectionPath.isEmpty)
    }

    @Test
    func test_navigate_routesEachTabToItsOwnPath() {
        sut.navigate(to: .setsList, on: .sets)
        sut.navigate(to: .deckList, on: .decks)
        sut.navigate(to: .peopleList, on: .loans)
        sut.navigate(to: .userCollection, on: .collection)

        #expect(sut.setsPath.count == 1)
        #expect(sut.deckPath.count == 1)
        #expect(sut.loanPath.count == 1)
        #expect(sut.collectionPath.count == 1)
    }
}
