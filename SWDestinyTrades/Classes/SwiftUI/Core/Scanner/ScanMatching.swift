//
//  ScanMatching.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreGraphics

/// A resolved scan: the catalog card plus a 0...1 match score.
struct ScannedCardResult: Equatable {
    let card: CardDTO
    let confidence: Float

    /// Confidence as a 0–100 integer, safe against NaN/out-of-range values.
    var confidencePercent: Int {
        guard confidence.isFinite else { return 0 }
        return Int((max(0, min(1, confidence)) * 100).rounded())
    }

    static func == (lhs: ScannedCardResult, rhs: ScannedCardResult) -> Bool {
        lhs.card.code == rhs.card.code && lhs.confidence == rhs.confidence
    }
}

protocol CardScanMatching: AnyObject {
    /// Returns the best catalog matches, best first. CPU-bound — call off the main thread.
    /// Implementations must be safe to call from a background queue (read-only after init).
    func matches(_ image: CGImage, limit: Int) -> [ScannedCardResult]
}
