//
//  CompatibilityLayerPropertyTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit
import XCTest

@testable import SWDestinyTrades

final class CompatibilityLayerPropertyTests: XCTestCase {

    private var window: UIWindow!
    private var navigationController: UINavigationController!
    private var hybridNavigationManager: HybridNavigationManager!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
        hybridNavigationManager = HybridNavigationManager(uikitNavigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        window.isHidden = true
        window = nil
        navigationController = nil
        hybridNavigationManager = nil
        super.tearDown()
    }

    func testCompatibilityLayerInteroperability() {
        testUIKitViewWrapperIntegration()

        testSwiftUIHostingControllerIntegration()

        testHybridNavigationInteroperability()

        testCrossFrameworkErrorHandling()
    }

    // MARK: - UIKit View Integration Tests

    func testUIKitViewWrapperIntegration() {
        let tableViewWrapper = UIKitViewWrapper.tableView { tableView in
            tableView.backgroundColor = .systemBackground
            tableView.separatorStyle = .singleLine
        }

        let hostingController = UIHostingController(rootView: tableViewWrapper)

        XCTAssertNotNil(hostingController.view, "Hosting controller should have a view")

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)

        let collectionViewWrapper = UIKitViewWrapper.collectionView(layout: layout) { collectionView in
            collectionView.backgroundColor = .systemBackground
        }

        let collectionHostingController = UIHostingController(rootView: collectionViewWrapper)
        XCTAssertNotNil(collectionHostingController.view, "Collection view hosting controller should have a view")

//        let errorWrapper = UIKitViewWrapper(
//            view: UIView(),
//            configure: { _ in
//                throw UIKitIntegrationError.configurationFailed("Test error")
//            },
//            onError: { _ in
//            }
//        )

//        let errorHostingController = UIHostingController(rootView: errorWrapper)
//        XCTAssertNotNil(errorHostingController.view, "Error wrapper should still create a view")
    }

    // MARK: - SwiftUI Integration Tests

    func testSwiftUIHostingControllerIntegration() {
        let swiftUIView = TestSwiftUIView()
        let hostingController = SwiftUIHostingController(rootView: swiftUIView)

        XCTAssertNotNil(hostingController.view, "SwiftUI hosting controller should have a view")
        XCTAssertEqual(hostingController.title, nil, "Hosting controller should not have a default title")

        var viewDidAppearCalled = false
        var viewDidDisappearCalled = false

        let callbackHostingController = SwiftUIHostingController(
            rootView: swiftUIView,
            onError: { _ in },
            onViewDidAppear: { viewDidAppearCalled = true },
            onViewDidDisappear: { viewDidDisappearCalled = true }
        )

        callbackHostingController.viewDidAppear(false)
        XCTAssertTrue(viewDidAppearCalled, "viewDidAppear callback should be called")

        callbackHostingController.viewDidDisappear(false)
        XCTAssertTrue(viewDidDisappearCalled, "viewDidDisappear callback should be called")

        let modalController = SwiftUIHostingControllerFactory.modal(
            swiftUIView,
            backgroundColor: .systemBackground
        )
        XCTAssertEqual(modalController.modalPresentationStyle, .pageSheet, "Modal controller should have correct presentation style")
        XCTAssertEqual(modalController.customBackgroundColor, .systemBackground, "Modal controller should have custom background color")

        let navigationHostingController = SwiftUIHostingControllerFactory.navigation(
            swiftUIView,
            backgroundColor: .systemBackground
        )
        XCTAssertFalse(navigationHostingController.shouldAutoResize, "Navigation controller should not auto-resize")

        let tabBarController = SwiftUIHostingControllerFactory.tabBarItem(
            swiftUIView,
            title: "Test Tab",
            image: UIImage(systemName: "star")
        )
        XCTAssertEqual(tabBarController.tabBarItem.title, "Test Tab", "Tab bar controller should have correct title")
    }

    // MARK: - Hybrid Navigation Tests

    func testHybridNavigationInteroperability() {
        let coordinator = NavigationCoordinator()

        let cardDestination = AppDestination.cardDetail([], CardDTO.stub())
        coordinator.navigate(to: cardDestination)

        XCTAssertFalse(coordinator.cardPath.isEmpty, "Navigation should add destination to path")

        coordinator.selectedTab = .decks
        let deckDestination = AppDestination.deckBuilder(nil)
        coordinator.navigate(to: deckDestination)

        XCTAssertFalse(coordinator.deckPath.isEmpty, "Navigation should add destination to deck path")
        XCTAssertTrue(coordinator.cardPath.isEmpty, "Card path should remain empty")

        coordinator.pop()
        XCTAssertTrue(coordinator.deckPath.isEmpty, "Pop should remove last destination")

        // Test pop to root
        coordinator.navigate(to: deckDestination)
        coordinator.navigate(to: AppDestination.deckGraph(DeckDTO.stub()))
        XCTAssertEqual(coordinator.deckPath.count, 2, "Should have two destinations in path")

        coordinator.popToRoot()
        XCTAssertTrue(coordinator.deckPath.isEmpty, "Pop to root should clear all destinations")

        hybridNavigationManager.navigationMode = .hybrid

        hybridNavigationManager.navigate(to: AppDestination.setsList)

        coordinator.navigationError = NavigationError.navigationFailed("Test error")
        XCTAssertNotNil(coordinator.navigationError, "Navigation error should be set")

        coordinator.clearError()
        XCTAssertNil(coordinator.navigationError, "Navigation error should be cleared")
    }

    // MARK: - Error Handling Tests

    func testCrossFrameworkErrorHandling() {
        var errorCaught: Error?
        let errorBoundary = ErrorBoundary(
            content: {
                TestSwiftUIView()
            },
            onError: { error in
                errorCaught = error
            }
        )

        let hostingController = UIHostingController(rootView: errorBoundary)
        XCTAssertNotNil(hostingController.view, "Error boundary should create a view")

        // Test UIKit integration error handling
        let integrationError = UIKitIntegrationError.viewCreationFailed("Test creation error")
        XCTAssertEqual(integrationError.localizedDescription, "Failed to create UIKit view: Test creation error")

        let swiftUIError = SwiftUIIntegrationError.hostingControllerCreationFailed("Test hosting error")
        XCTAssertEqual(swiftUIError.localizedDescription, "Failed to create SwiftUI hosting controller: Test hosting error")
    }

    // MARK: - Integration Stress Tests

    func testMultipleFrameworkTransitions() {
        for index in 0 ..< 5 {
            let swiftUIView = TestSwiftUIView(text: "View \(index)")
            let hostingController = SwiftUIHostingController(rootView: swiftUIView)

            navigationController.pushViewController(hostingController, animated: false)

            let uikitWrapper = UIKitViewWrapper(view: UILabel()) { label in
                label.text = "UIKit Label \(index)"
                label.textAlignment = .center
            }

            let wrapperHostingController = UIHostingController(rootView: uikitWrapper)
            navigationController.pushViewController(wrapperHostingController, animated: false)
        }

        XCTAssertEqual(navigationController.viewControllers.count, 11, "Should have 11 view controllers (1 root + 10 pushed)")

        navigationController.popToRootViewController(animated: false)
        XCTAssertEqual(navigationController.viewControllers.count, 1, "Should return to root controller")
    }
}

// MARK: - Test Helper Views

private struct TestSwiftUIView: View {
    let text: String

    init(text: String = "Test SwiftUI View") {
        self.text = text
    }

    var body: some View {
        VStack {
            Text(text)
                .font(.title)
                .padding()

            Button("Test Button") {}
                .padding()
        }
        .background(Color.blue.opacity(0.1))
    }
}
