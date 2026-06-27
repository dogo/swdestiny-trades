//
//  ToastQueueTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class ToastQueueTests: XCTestCase {

    private var sut: ToastQueue!

    override func setUp() async throws {
        try await super.setUp()
        sut = ToastQueue()
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Enqueue

    func test_enqueue_whenEmpty_becomesCurrent() {
        sut.enqueue(title: "Saved", message: "Card added", type: .success)

        XCTAssertEqual(sut.current?.title, "Saved")
        XCTAssertEqual(sut.current?.message, "Card added")
        XCTAssertEqual(sut.current?.type, .success)
    }

    func test_enqueue_whenBusy_doesNotReplaceCurrent() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)

        XCTAssertEqual(sut.current?.title, "First")
    }

    // MARK: - Advance (FIFO)

    func test_advance_promotesQueuedItemsInOrder() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        sut.enqueue(title: "Third", message: "3", type: .info)

        sut.advance()
        XCTAssertEqual(sut.current?.title, "Second")

        sut.advance()
        XCTAssertEqual(sut.current?.title, "Third")
    }

    func test_advance_whenQueueEmpty_clearsCurrent() {
        sut.enqueue(title: "Only", message: "1", type: .info)

        sut.advance()

        XCTAssertNil(sut.current)
    }

    // MARK: - Cancel

    func test_cancel_currentItem_advancesToNext() throws {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        let currentId = try XCTUnwrap(sut.current?.id)

        sut.cancel(id: currentId)

        XCTAssertEqual(sut.current?.title, "Second")
    }

    func test_cancel_unknownId_keepsCurrentAndQueue() throws {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)
        let currentId = try XCTUnwrap(sut.current?.id)

        sut.cancel(id: UUID())

        // Current untouched and the queued item is still there to be promoted.
        XCTAssertEqual(sut.current?.id, currentId)
        sut.advance()
        XCTAssertEqual(sut.current?.title, "Second")
    }

    // MARK: - Cancel All

    func test_cancelAll_clearsEverything() {
        sut.enqueue(title: "First", message: "1", type: .info)
        sut.enqueue(title: "Second", message: "2", type: .info)

        sut.cancelAll()
        XCTAssertNil(sut.current)

        // Nothing is left to promote.
        sut.advance()
        XCTAssertNil(sut.current)
    }

    // MARK: - onDismiss callback

    func test_advance_firesOnDismissOfDismissedItem() async {
        let expectation = expectation(description: "onDismiss called")
        sut.enqueue(title: "First", message: "1", type: .success) {
            expectation.fulfill()
        }

        sut.advance()

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func test_cancelAll_doesNotFireOnDismiss() async {
        let expectation = expectation(description: "onDismiss must not be called")
        expectation.isInverted = true
        sut.enqueue(title: "First", message: "1", type: .success) {
            expectation.fulfill()
        }

        sut.cancelAll()

        await fulfillment(of: [expectation], timeout: 0.6)
    }
}
