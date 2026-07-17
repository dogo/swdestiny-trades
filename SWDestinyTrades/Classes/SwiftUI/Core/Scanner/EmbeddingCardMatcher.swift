//
//  EmbeddingCardMatcher.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreGraphics
import ImageIO

/// Matches a card crop to the catalog by embedding it with the fine-tuned MobileCLIP encoder and
/// finding the nearest scan embeddings. Tries all four orientations (cards get photographed sideways,
/// and Battlefields are landscape), keeping the best score per card.
nonisolated final class EmbeddingCardMatcher: CardScanMatching {

    /// Score at/above which a match is pre-selected in the review sheet. Real-photo scores run
    /// ~0.55–0.85 for the right card; tune from the values shown in the UI.
    static let defaultThreshold: Float = 0.45

    /// Below this the top match is too weak to be a real card (blank table / off-card crop) — treat
    /// the capture as unrecognized so the review shows the manual-search fallback.
    static let recognitionThreshold: Float = 0.35

    private static let orientations: [CGImagePropertyOrientation] = [.up, .right, .down, .left]

    private let embedder: MobileCLIPEmbedder
    private let index: CardEmbeddingIndex

    init(embedder: MobileCLIPEmbedder, index: CardEmbeddingIndex) {
        self.embedder = embedder
        self.index = index
    }

    func matches(_ image: CGImage, limit: Int) -> [CardScanMatch] {
        let queries = Self.orientations.compactMap { try? embedder.embed(image, orientation: $0) }
        guard !queries.isEmpty else { return [] }

        return index.nearest(toAny: queries, limit: limit).map { hit in
            CardScanMatch(code: hit.code, confidence: hit.score)
        }
    }
}
