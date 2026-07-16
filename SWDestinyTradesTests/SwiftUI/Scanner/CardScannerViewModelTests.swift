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

import CoreGraphics
import Testing

@testable import SWDestinyTrades

@MainActor
final class CardScannerViewModelTests: BaseTestCase {

    private var sut: CardScannerViewModel!

    override init() async throws {
        try await super.init()
        sut = CardScannerViewModel(dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
    }

    // MARK: - Default state

    @Test
    func freshViewModel_isNotReadyAndHasNoSelection() {
        #expect(sut.isReady == false)
        #expect(sut.selectedCount == 0)
        #expect(sut.isReviewPresented == false)
    }

    // MARK: - Dismiss review

    @Test
    func dismissReview_clearsPresentationState() {
        sut.isReviewPresented = true

        sut.dismissReview()

        #expect(sut.isReviewPresented == false)
    }

    @Test
    func addSelected_withNoCandidates_dismissesWithoutToast() {
        sut.isReviewPresented = true

        sut.addSelected()

        #expect(sut.isReviewPresented == false)
        #expect(sut.toastQueue.current == nil)
    }
}

// MARK: - ScanCandidate

@MainActor
final class ScanCandidateTests {

    private func result(code: String, confidence: Float) -> ScannedCardResult {
        ScannedCardResult(card: CardDTO.stub(code: code), confidence: confidence)
    }

    @Test
    func isRecognized_trueWhenMatchesPresent() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9)],
            chosenIndex: 0,
            isSelected: false
        )

        #expect(candidate.isRecognized)
    }

    @Test
    func isRecognized_falseWhenNoMatches() {
        let candidate = ScanCandidate(crop: TestImage.solid, matches: [], chosenIndex: 0, isSelected: false)

        #expect(candidate.isRecognized == false)
    }

    @Test
    func chosenMatch_returnsMatchAtChosenIndex() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9), result(code: "01002", confidence: 0.7)],
            chosenIndex: 1,
            isSelected: true
        )

        #expect(candidate.chosenMatch?.card.code == "01002")
    }

    @Test
    func chosenMatch_outOfBounds_returnsNil() {
        let candidate = ScanCandidate(
            crop: TestImage.solid,
            matches: [result(code: "01001", confidence: 0.9)],
            chosenIndex: 5,
            isSelected: false
        )

        #expect(candidate.chosenMatch == nil)
    }
}

// MARK: - ScannedCardResult

@MainActor
final class ScannedCardResultTests {

    @Test
    func confidencePercent_roundsToInteger() {
        let result = ScannedCardResult(card: CardDTO.stub(), confidence: 0.846)
        #expect(result.confidencePercent == 85)
    }

    @Test
    func confidencePercent_clampsOutOfRange() {
        #expect(ScannedCardResult(card: CardDTO.stub(), confidence: 1.5).confidencePercent == 100)
        #expect(ScannedCardResult(card: CardDTO.stub(), confidence: -0.5).confidencePercent == 0)
    }

    @Test
    func confidencePercent_nanIsZero() {
        #expect(ScannedCardResult(card: CardDTO.stub(), confidence: .nan).confidencePercent == 0)
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
