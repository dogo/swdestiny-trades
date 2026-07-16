//
//  ToastQueueTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class ToastQueueTests {

    private var sut: ToastQueue!

    init() async throws {
        sut = ToastQueue()
    }

    isolated deinit {
        sut = nil
    }

    // MARK: - Enqueue

    @Test
    func enqueue_whenEmpty_becomesCurrent() {
        sut.enqueue(title: "Saved", message: "Card added", type: .success)

        #expect(sut.current?.title == "Saved")
        #expect(sut.current?.message == "Card added")
        #expect(sut.current?.type == .success)
    }

    @Test
    func enqueue_whenBusy_doesNotReplaceCurrent() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)

        #expect(sut.current?.title == "First")
    }

    // MARK: - Advance (FIFO)

    @Test
    func advance_promotesQueuedItemsInOrder() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        sut.enqueue(title: "Third", message: "3", type: .info)

        sut.advance()
        #expect(sut.current?.title == "Second")

        sut.advance()
        #expect(sut.current?.title == "Third")
    }

    @Test
    func advance_whenQueueEmpty_clearsCurrent() {
        sut.enqueue(title: "Only", message: "1", type: .info)

        sut.advance()

        #expect(sut.current == nil)
    }

    // MARK: - Cancel

    @Test
    func cancel_currentItem_advancesToNext() throws {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        let currentId = try #require(sut.current?.id)

        sut.cancel(id: currentId)

        #expect(sut.current?.title == "Second")
    }

    @Test
    func cancel_unknownId_keepsCurrentAndQueue() throws {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        let currentId = try #require(sut.current?.id)

        sut.cancel(id: UUID())

        // Current untouched and the queued item is still there to be promoted.
        #expect(sut.current?.id == currentId)
        sut.advance()
        #expect(sut.current?.title == "Second")
    }

    // MARK: - Cancel All

    @Test
    func cancelAll_clearsEverything() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)

        sut.cancelAll()
        #expect(sut.current == nil)

        // Nothing is left to promote.
        sut.advance()
        #expect(sut.current == nil)
    }

    // MARK: - onDismiss callback

    @Test
    func advance_firesOnDismissOfDismissedItem() async {
        await confirmation("onDismiss called") { confirm in
            sut.enqueue(title: "First", message: "1", type: .success) {
                confirm()
            }

            sut.advance()
            try? await Task.sleep(for: .milliseconds(400))
        }
    }

    @Test
    func cancelAll_doesNotFireOnDismiss() async {
        await confirmation("onDismiss must not be called", expectedCount: 0) { confirm in
            sut.enqueue(title: "First", message: "1", type: .success) {
                confirm()
            }

            sut.cancelAll()
            try? await Task.sleep(for: .milliseconds(600))
        }
    }
}
