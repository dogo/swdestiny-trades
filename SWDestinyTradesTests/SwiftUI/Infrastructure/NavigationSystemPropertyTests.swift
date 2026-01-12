////
////  NavigationSystemPropertyTests.swift
////  SWDestinyTradesTests
////
////  Created by Diogo Autilio on 11/01/26.
////  Copyright © 2026 Diogo Autilio. All rights reserved.
////
//
// import SwiftUI
// import XCTest
//
// @testable import SWDestinyTrades
//
// final class NavigationSystemPropertyTests: XCTestCase {
//
//    private var navigationCoordinator: NavigationCoordinator!
//    private var hybridNavigationManager: HybridNavigationManager!
//    private var appState: AppState!
//    private var dependencyContainer: DependencyContainer!
//
//    override func setUp() {
//        super.setUp()
//        navigationCoordinator = NavigationCoordinator()
//        hybridNavigationManager = HybridNavigationManager()
//        appState = AppState()
//        dependencyContainer = DependencyContainer.shared
//    }
//
//    override func tearDown() {
//        navigationCoordinator = nil
//        hybridNavigationManager = nil
//        appState = nil
//        dependencyContainer = nil
//        super.tearDown()
//    }
//
//    func testNavigationSystemConsistency() {
//        testNavigationStackUsageForAllTabs()
//
//        testNavigationHierarchyMaintenance()
//
//        testTabSpecificNavigationPaths()
//
//        testNavigationStatePreservation()
//
//        testNavigationErrorHandling()
//    }
//
//    // MARK: - NavigationStack Usage Tests
//
//    func testNavigationStackUsageForAllTabs() {
//        let allTabs = AppTab.allCases
//
//        for tab in allTabs {
//            navigationCoordinator.selectedTab = tab
//            let pathBinding = navigationCoordinator.path(for: tab)
//
//            XCTAssertNotNil(pathBinding, "Each tab should have a navigation path binding")
//            XCTAssertTrue(pathBinding.wrappedValue.isEmpty, "Navigation paths should start empty")
//        }
//
//        navigationCoordinator.selectedTab = .cards
//        navigationCoordinator.navigate(to: .setsList)
//
//        navigationCoordinator.selectedTab = .decks
//        navigationCoordinator.navigate(to: .deckList)
//
//        XCTAssertFalse(navigationCoordinator.cardPath.isEmpty, "Cards path should contain navigation")
//        XCTAssertFalse(navigationCoordinator.deckPath.isEmpty, "Decks path should contain navigation")
//        XCTAssertTrue(navigationCoordinator.loanPath.isEmpty, "Loans path should remain empty")
//        XCTAssertTrue(navigationCoordinator.collectionPath.isEmpty, "Collection path should remain empty")
//    }
//
//    // MARK: - Navigation Hierarchy Tests
//
//    func testNavigationHierarchyMaintenance() {
//        navigationCoordinator.selectedTab = .cards
//
//        navigationCoordinator.navigate(to: .setsList)
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 1, "Should have one destination in cards path")
//
//        let testSet = SetDTO.stub(name: "Test Set", code: "TS")
//        navigationCoordinator.navigate(to: .cardList(testSet))
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 2, "Should have two destinations in cards path")
//
//        let testCard = CardDTO.stub()
//        navigationCoordinator.navigate(to: .cardDetail(testCard))
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 3, "Should have three destinations in cards path")
//
//        navigationCoordinator.selectedTab = .decks
//
//        navigationCoordinator.navigate(to: .deckList)
//        XCTAssertEqual(navigationCoordinator.deckPath.count, 1, "Should have one destination in decks path")
//
//        let testDeck = DeckDTO.stub()
//        navigationCoordinator.navigate(to: .deckBuilder(testDeck))
//        XCTAssertEqual(navigationCoordinator.deckPath.count, 2, "Should have two destinations in decks path")
//
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 3, "Cards path should be preserved when switching tabs")
//    }
//
//    // MARK: - Tab-Specific Navigation Tests
//
//    func testTabSpecificNavigationPaths() {
//        let cardsDestinations: [AppDestination] = [
//            .setsList,
//            .cardList(SetDTO.stub()),
//            .cardDetail(CardDTO.stub()),
//            .search
//        ]
//
//        let decksDestinations: [AppDestination] = [
//            .deckList,
//            .deckBuilder(nil),
//            .deckBuilder(DeckDTO.stub()),
//            .deckGraph(DeckDTO.stub()),
//            .addToDeck(DeckDTO.stub())
//        ]
//
//        let loansDestinations: [AppDestination] = [
//            .peopleList,
//            .newPerson,
//            .loanDetail(PersonDTO.stub())
//        ]
//
//        let collectionDestinations: [AppDestination] = [
//            .userCollection,
//            .addCard(nil),
//            .addCard(SetDTO.stub())
//        ]
//
//        navigationCoordinator.selectedTab = .cards
//        for destination in cardsDestinations {
//            navigationCoordinator.navigate(to: destination)
//        }
//        XCTAssertEqual(navigationCoordinator.cardPath.count, cardsDestinations.count,
//                       "Cards path should contain all navigated destinations")
//
//        navigationCoordinator.selectedTab = .decks
//        for destination in decksDestinations {
//            navigationCoordinator.navigate(to: destination)
//        }
//        XCTAssertEqual(navigationCoordinator.deckPath.count, decksDestinations.count,
//                       "Decks path should contain all navigated destinations")
//
//        navigationCoordinator.selectedTab = .loans
//        for destination in loansDestinations {
//            navigationCoordinator.navigate(to: destination)
//        }
//        XCTAssertEqual(navigationCoordinator.loanPath.count, loansDestinations.count,
//                       "Loans path should contain all navigated destinations")
//
//        navigationCoordinator.selectedTab = .collection
//        for destination in collectionDestinations {
//            navigationCoordinator.navigate(to: destination)
//        }
//        XCTAssertEqual(navigationCoordinator.collectionPath.count, collectionDestinations.count,
//                       "Collection path should contain all navigated destinations")
//    }
//
//    // MARK: - Navigation State Preservation Tests
//
//    func testNavigationStatePreservation() {
//        navigationCoordinator.selectedTab = .cards
//        navigationCoordinator.navigate(to: .setsList)
//        navigationCoordinator.navigate(to: .cardList(SetDTO.stub()))
//
//        navigationCoordinator.selectedTab = .decks
//        navigationCoordinator.navigate(to: .deckList)
//        navigationCoordinator.navigate(to: .deckBuilder(nil))
//
//        navigationCoordinator.selectedTab = .loans
//        navigationCoordinator.navigate(to: .peopleList)
//
//        navigationCoordinator.selectedTab = .collection
//        navigationCoordinator.navigate(to: .userCollection)
//
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 2, "Cards path should be preserved")
//        XCTAssertEqual(navigationCoordinator.deckPath.count, 2, "Decks path should be preserved")
//        XCTAssertEqual(navigationCoordinator.loanPath.count, 1, "Loans path should be preserved")
//        XCTAssertEqual(navigationCoordinator.collectionPath.count, 1, "Collection path should be preserved")
//
//        navigationCoordinator.selectedTab = .cards
//        navigationCoordinator.pop()
//        XCTAssertEqual(navigationCoordinator.cardPath.count, 1, "Pop should remove last destination")
//
//        navigationCoordinator.popToRoot()
//        XCTAssertTrue(navigationCoordinator.cardPath.isEmpty, "Pop to root should clear all destinations")
//
//        XCTAssertEqual(navigationCoordinator.deckPath.count, 2, "Other tabs should be unaffected by pop operations")
//    }
//
//    // MARK: - Error Handling Tests
//
//    func testNavigationErrorHandling() {
//        XCTAssertNil(navigationCoordinator.navigationError, "Should start with no errors")
//
//        let testError = NavigationError.navigationFailed("Test navigation failure")
//        navigationCoordinator.navigationError = testError
//
//        XCTAssertNotNil(navigationCoordinator.navigationError, "Error should be set")
//        XCTAssertEqual(navigationCoordinator.navigationError?.localizedDescription,
//                       "Navigation failed: Test navigation failure",
//                       "Error message should match")
//
//        navigationCoordinator.clearError()
//        XCTAssertNil(navigationCoordinator.navigationError, "Error should be cleared")
//
//        let authError = NavigationError.authenticationRequired
//        navigationCoordinator.navigationError = authError
//        XCTAssertEqual(navigationCoordinator.navigationError?.localizedDescription,
//                       "Authentication required for this action",
//                       "Authentication error should have correct message")
//
//        let destinationError = NavigationError.destinationNotFound("TestDestination")
//        navigationCoordinator.navigationError = destinationError
//        XCTAssertEqual(navigationCoordinator.navigationError?.localizedDescription,
//                       "Destination not found: TestDestination",
//                       "Destination error should have correct message")
//    }
//
//    // MARK: - Cross-Tab Navigation Tests
//
//    func testCrossTabNavigation() {
//        navigationCoordinator.selectedTab = .cards
//
//        let deckDestination = AppDestination.deckBuilder(nil)
//        navigationCoordinator.navigate(to: deckDestination, on: .decks)
//
//        XCTAssertEqual(navigationCoordinator.selectedTab, .decks, "Should switch to target tab")
//
//        let expectation = XCTestExpectation(description: "Cross-tab navigation should complete")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            XCTAssertFalse(self.navigationCoordinator.deckPath.isEmpty, "Should navigate to destination on target tab")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    // MARK: - Hybrid Navigation Tests
//
//    func testHybridNavigationManager() {
//        hybridNavigationManager.navigationMode = .swiftUI
//        hybridNavigationManager.navigate(to: .setsList)
//
//        XCTAssertFalse(hybridNavigationManager.swiftUICoordinator.cardPath.isEmpty,
//                       "SwiftUI mode should use SwiftUI coordinator")
//
//        hybridNavigationManager.navigationMode = .hybrid
//
//        hybridNavigationManager.navigate(to: .setsList)
//
//        hybridNavigationManager.navigate(to: .about)
//
//        XCTAssertNotNil(hybridNavigationManager.swiftUICoordinator, "Hybrid manager should have SwiftUI coordinator")
//    }
//
//    // MARK: - AppDestination Tests
//
//    func testAppDestinationProperties() {
//        XCTAssertEqual(AppDestination.setsList.title, "Sets", "Sets destination should have correct title")
//        XCTAssertEqual(AppDestination.cardDetail(CardDTO.stub()).title, "Card Detail", "Card detail should have correct title")
//        XCTAssertEqual(AppDestination.deckBuilder(nil).title, "New Deck", "New deck should have correct title")
//        XCTAssertEqual(AppDestination.deckBuilder(DeckDTO.stub()).title, "Edit Deck", "Edit deck should have correct title")
//
//        XCTAssertTrue(AppDestination.userCollection.requiresAuthentication, "User collection should require authentication")
//        XCTAssertTrue(AppDestination.addCard(nil).requiresAuthentication, "Add card should require authentication")
//        XCTAssertTrue(AppDestination.deckBuilder(nil).requiresAuthentication, "Deck builder should require authentication")
//        XCTAssertFalse(AppDestination.setsList.requiresAuthentication, "Sets list should not require authentication")
//        XCTAssertFalse(AppDestination.search.requiresAuthentication, "Search should not require authentication")
//    }
//
//    // MARK: - AppTab Tests
//
//    func testAppTabProperties() {
//        let allTabs = AppTab.allCases
//        XCTAssertEqual(allTabs.count, 4, "Should have exactly 4 tabs")
//        XCTAssertTrue(allTabs.contains(.cards), "Should contain cards tab")
//        XCTAssertTrue(allTabs.contains(.decks), "Should contain decks tab")
//        XCTAssertTrue(allTabs.contains(.loans), "Should contain loans tab")
//        XCTAssertTrue(allTabs.contains(.collection), "Should contain collection tab")
//
//        XCTAssertEqual(AppTab.cards.title, "Cards", "Cards tab should have correct title")
//        XCTAssertEqual(AppTab.cards.icon, "ic_cards", "Cards tab should have correct icon")
//        XCTAssertEqual(AppTab.cards.selectedIcon, "ic_cards_filled", "Cards tab should have correct selected icon")
//
//        XCTAssertEqual(AppTab.decks.title, "Decks", "Decks tab should have correct title")
//        XCTAssertEqual(AppTab.loans.title, "Loans", "Loans tab should have correct title")
//        XCTAssertEqual(AppTab.collection.title, "Collection", "Collection tab should have correct title")
//    }
//
//    // MARK: - Performance Tests
//
//    func testNavigationPerformance() {
//        measure {
//            for index in 0 ..< 100 {
//                let tab = AppTab.allCases[index % 4]
//                navigationCoordinator.selectedTab = tab
//
//                switch tab {
//                case .cards:
//                    navigationCoordinator.navigate(to: .setsList)
//                case .decks:
//                    navigationCoordinator.navigate(to: .deckList)
//                case .loans:
//                    navigationCoordinator.navigate(to: .peopleList)
//                case .collection:
//                    navigationCoordinator.navigate(to: .userCollection)
//                }
//
//                if index.isMultiple(of: 10) {
//                    navigationCoordinator.popToRoot()
//                }
//            }
//        }
//    }
//
//    // MARK: - Integration Tests
//
//    func testMainTabViewIntegration() {
//        let mainTabView = MainTabView()
//            .environmentObject(appState)
//            .environment(\.dependencyContainer, dependencyContainer)
//            .environment(\.viewModelFactory, ViewModelFactory(container: dependencyContainer))
//
//        XCTAssertNotNil(mainTabView, "MainTabView should be creatable with proper environment")
//
//        let coordinator = NavigationCoordinator()
//        let tabViewWithCoordinator = MainTabView()
//            .environmentObject(coordinator)
//            .environmentObject(appState)
//
//        XCTAssertNotNil(tabViewWithCoordinator, "MainTabView should work with custom navigation coordinator")
//    }
// }
