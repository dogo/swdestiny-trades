//
//  CardScannerViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AVFoundation
import CoreGraphics
import SwiftUI

@MainActor
@Observable
final class CardScannerViewModel: BaseViewModel {

    enum CameraState {
        case idle
        case authorized
        case denied
    }

    enum IndexState: Equatable {
        case idle
        case building(Double)
        case ready
        case failed
    }

    private(set) var cameraState: CameraState = .idle
    private(set) var indexState: IndexState = .idle
    private(set) var reviewCandidates: [ScanCandidate] = []
    var isReviewPresented = false

    var isReady: Bool {
        indexState == .ready
    }

    var selectedCount: Int {
        reviewCandidates.filter(\.isSelected).count
    }

    var previewSession: AVCaptureSession {
        cameraSession.captureSession
    }

    private let pipeline = ScanFramePipeline()
    private let injectedMatcher: CardScanMatching?
    private var cardsByCode: [String: CardDTO] = [:]

    @ObservationIgnored
    lazy var cameraSession = CameraSession { [weak self, pipeline] pixelBuffer in
        // Runs on the camera sample queue — cropping + matching stay off the main thread.
        guard let candidates = pipeline.process(pixelBuffer) else { return }
        Task { @MainActor in
            self?.presentReview(for: candidates)
        }
    }

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(matcher: CardScanMatching? = nil, dependencyContainer: DependencyContainer = .shared) {
        injectedMatcher = matcher
        super.init(dependencyContainer: dependencyContainer)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        injectedMatcher = nil
        super.init(dependencyContainer: dependencyContainer)
    }

    // MARK: - Lifecycle

    func onAppear() async {
        switch cameraSession.authorizationStatus {
        case .authorized:
            cameraState = .authorized
        case .notDetermined:
            cameraState = await cameraSession.requestAccess() ? .authorized : .denied
        default:
            cameraState = .denied
        }

        guard cameraState == .authorized else { return }
        await startCamera()
        await prepareMatcher()
    }

    func onDisappear() {
        let cameraSession = cameraSession
        Task {
            await cameraSession.stop()
        }
    }

    // MARK: - Actions

    /// Captures the current frame: the next frame detects all cards and matches each.
    func capture() {
        guard isReady else { return }
        pipeline.requestCapture()
    }

    func toggle(_ candidate: ScanCandidate) {
        guard let index = reviewCandidates.firstIndex(where: { $0.id == candidate.id }) else { return }
        reviewCandidates[index].isSelected.toggle()
    }

    /// Pick a different match from the candidate's top list (e.g. when the top guess is wrong).
    func choose(_ candidate: ScanCandidate, index: Int) {
        guard let row = reviewCandidates.firstIndex(where: { $0.id == candidate.id }) else { return }
        reviewCandidates[row].chosenIndex = index
        reviewCandidates[row].isSelected = true
    }

    func addSelected() {
        let cards = reviewCandidates.filter(\.isSelected).compactMap(\.chosenMatch).map(\.card)
        guard !cards.isEmpty else {
            dismissReview()
            return
        }
        Task { @MainActor in
            let writer = CollectionCardWriter(database: database)
            var added = 0
            for card in cards {
                // Skip duplicates / failures silently; the summary reports what landed.
                guard await (try? writer.addToCollection(card)) != nil else { continue }
                added += 1
            }
            toastQueue.enqueue(title: L10n.cardAdded, message: L10n.scanAddedSummary(added), type: .success)
            dismissReview()
        }
    }

    func dismissReview() {
        isReviewPresented = false
        reviewCandidates = []
    }

    // MARK: - Camera pipeline

    private func startCamera() async {
        await cameraSession.start()
    }

    private func presentReview(for candidates: [ScanFramePipeline.Candidate]) {
        guard !candidates.isEmpty else {
            toastQueue.enqueue(title: L10n.scanNoCardDetected, message: L10n.scanPointAtCards, type: .info)
            return
        }
        reviewCandidates = candidates.map { candidate in
            let matches = candidate.matches.compactMap { match in
                cardsByCode[match.code].map { card in
                    ScannedCardResult(card: card, confidence: match.confidence)
                }
            }
            let best = matches.first?.confidence ?? 0
            // Too weak to be a real card → unrecognized (drives the "Not recognized" + manual-search UX).
            guard best >= EmbeddingCardMatcher.recognitionThreshold else {
                return ScanCandidate(crop: candidate.crop, matches: [], chosenIndex: 0, isSelected: false)
            }
            let confident = best >= EmbeddingCardMatcher.defaultThreshold
            return ScanCandidate(crop: candidate.crop, matches: matches, chosenIndex: 0, isSelected: confident)
        }
        isReviewPresented = true
    }

    // MARK: - Matcher

    private func prepareMatcher() async {
        guard pipeline.matcher == nil else { return }

        // Feedback while the catalog loads, otherwise the screen looks idle (button disabled).
        indexState = .building(0)

        let cards = await (try? service.retrieveAllCards()) ?? []
        cardsByCode = Dictionary(cards.map { ($0.code, $0) }) { first, _ in first }

        if let injectedMatcher {
            pipeline.matcher = injectedMatcher
            indexState = .ready
            return
        }

        guard !cards.isEmpty,
              let embedder = MobileCLIPEmbedder.bundled(),
              let url = Bundle.main.url(forResource: "card-embeddings", withExtension: "swdx"),
              let entries = try? CardEmbeddingIndex.load(from: url),
              !entries.isEmpty else {
            indexState = .failed
            return
        }

        let index = CardEmbeddingIndex(entries: entries)
        pipeline.matcher = EmbeddingCardMatcher(embedder: embedder, index: index)
        indexState = .ready
    }
}

/// One card from a capture, shown in the review sheet, with the top matches to choose from.
struct ScanCandidate: Identifiable {
    let id = UUID()
    let crop: CGImage
    let matches: [ScannedCardResult]
    var chosenIndex: Int
    var isSelected: Bool

    var isRecognized: Bool {
        !matches.isEmpty
    }

    var chosenMatch: ScannedCardResult? {
        matches.indices.contains(chosenIndex) ? matches[chosenIndex] : nil
    }
}
