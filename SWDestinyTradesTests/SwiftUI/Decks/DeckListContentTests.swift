//
//  DeckListContentTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 16/07/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import SwiftUI
import Testing
import UIKit

@testable import SWDestinyTrades

@MainActor
@Observable
private final class DeckListContentState {
    var items: [DeckListItem]

    init(items: [DeckListItem]) {
        self.items = items
    }
}

private struct DeckListContentHarness: View {
    let state: DeckListContentState

    var body: some View {
        DeckListContent(
            items: state.items,
            onEdit: { _ in },
            onGraph: { _ in },
            onDelete: { _ in },
            onRename: { _, _ in }
        )
    }
}

@MainActor
final class DeckListContentTests {

    @Test
    func replacingItemWithSameIDRendersUpdatedName() throws {
        let deckID = "deck-id"
        let state = DeckListContentState(items: [makeItem(id: deckID, name: "Old Name")])
        let controller = UIHostingController(rootView: DeckListContentHarness(state: state))
        let frame = CGRect(x: 0, y: 0, width: 390, height: 200)

        controller.view.frame = frame
        renderPendingUpdates(in: controller.view)
        let originalRendering = try #require(renderedData(for: controller.view))

        state.items = [makeItem(id: deckID, name: "New Name")]
        renderPendingUpdates(in: controller.view)
        let updatedRendering = try #require(renderedData(for: controller.view))

        #expect(originalRendering != updatedRendering)
    }

    private func makeItem(id: String, name: String) -> DeckListItem {
        let deck = DeckDTO()
        deck.id = id
        deck.name = name
        return DeckListItem(deck: deck)
    }

    private func renderPendingUpdates(in view: UIView) {
        view.layoutIfNeeded()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        view.layoutIfNeeded()
    }

    private func renderedData(for view: UIView) -> Data? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }.pngData()
    }
}
