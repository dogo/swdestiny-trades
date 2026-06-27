//
//  CardScannerViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//
//  Note: The camera-driven paths (onAppear, capture, presentReview, the
//  matcher build) require device hardware and private(set) state with no
//  injection seam, so they are exercised via UI/integration rather than here.
//  These tests cover the unit-testable surface: the value-type scan logic and
//  the view model's review-dismissal state.

import XCTest

@testable import SWDestinyTrades

@MainActor
final class CardScannerViewModelTests: BaseTestCase {

    private var sut: CardScannerViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = CardScannerViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Default state

    func test_freshViewModel_isNotReadyAndHasNoSelection() {
        XCTAssertFalse(sut.isReady)
        XCTAssertEqual(sut.selectedCount, 0)
        XCTAssertFalse(sut.isReviewPresented)
    }

    // MARK: - Dismiss review

    func test_dismissReview_clearsPresentationState() {
        sut.isReviewPresented = true

        sut.dismissReview()

        XCTAssertFalse(sut.isReviewPresented)
    }

    func test_addSelected_withNoCandidates_dismissesWithoutToast() {
        sut.isReviewPresented = true

        sut.addSelected()

        XCTAssertFalse(sut.isReviewPresented)
        XCTAssertNil(sut.toastQueue.current)
    }
}

// MARK: - ScanCandidate

@MainActor
final class ScanCandidateTests: XCTestCase {

    private func result(code: String, confidence: Float) -> ScannedCardResult {
        ScannedCardResult(card: CardDTO.stub(code: code), confidence: confidence)
    }

    func test_isRecognized_trueWhenMatchesPresent() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9)],
            chosenIndex: 0,
            isSelected: false
        )

        XCTAssertTrue(candidate.isRecognized)
    }

    func test_isRecognized_falseWhenNoMatches() {
        let candidate = ScanCandidate(crop: TestImage.solid, matches: [], chosenIndex: 0, isSelected: false)

        XCTAssertFalse(candidate.isRecognized)
    }

    func test_chosenMatch_returnsMatchAtChosenIndex() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9), result(code: "01002", confidence: 0.7)],
            chosenIndex: 1,
            isSelected: true
        )

        XCTAssertEqual(candidate.chosenMatch?.card.code, "01002")
    }

    func test_chosenMatch_outOfBounds_returnsNil() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9)],
            chosenIndex: 5,
            isSelected: false
        )

        XCTAssertNil(candidate.chosenMatch)
    }
}

// MARK: - ScannedCardResult

final class ScannedCardResultTests: XCTestCase {

    func test_confidencePercent_roundsToInteger() {
        let result = ScannedCardResult(card: CardDTO.stub(), confidence: 0.846)
        XCTAssertEqual(result.confidencePercent, 85)
    }

    func test_confidencePercent_clampsOutOfRange() {
        XCTAssertEqual(ScannedCardResult(card: CardDTO.stub(), confidence: 1.5).confidencePercent, 100)
        XCTAssertEqual(ScannedCardResult(card: CardDTO.stub(), confidence: -0.5).confidencePercent, 0)
    }

    func test_confidencePercent_nanIsZero() {
        XCTAssertEqual(ScannedCardResult(card: CardDTO.stub(), confidence: .nan).confidencePercent, 0)
    }
}

// MARK: - Test image helper

private enum TestImage {
    /// A 1x1 opaque CGImage for value-type tests that just need a non-nil crop.
    static let solid: CGImage = {
        let context = CGContext(
            data: nil,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        return context.makeImage()!
    }()
}
