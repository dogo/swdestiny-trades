//
//  ScanFramePipeline.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreImage
import CoreVideo
import Synchronization

/// Crops the framed card and matches it on capture.
///
/// We crop a fixed card-aspect region in the center of the frame (matching the on-screen guide)
/// rather than relying on rectangle detection — Vision's rectangle detector tends to lock onto the
/// card's inner art window (e.g. the character's face) instead of the rounded-corner card outline,
/// which produced crops that didn't match the full-card index.
///
/// Lives off the main actor: the camera delivers frames on its sample queue and calls `process`
/// there, so cropping and Vision embedding never touch the main thread.
/// Matcher replacement and capture requests cross executors, so that state lives in a compiler-
/// checked `Mutex`; image processing remains synchronous on the serial sample queue.
nonisolated final class ScanFramePipeline: Sendable {

    private struct State {
        var matcher: CardScanMatching?
        var captureRequested = false
    }

    struct Candidate: Sendable {
        let crop: CGImage
        let matches: [CardScanMatch]
    }

    /// Standard trading-card aspect ratio (63mm × 88mm), width / height.
    static let cardAspect: CGFloat = 0.716

    private let ciContext = CIContext(options: nil)
    private let state = Mutex(State())

    var matcher: CardScanMatching? {
        get { state.withLock { $0.matcher } }
        set { state.withLock { $0.matcher = newValue } }
    }

    func requestCapture() {
        state.withLock { $0.captureRequested = true }
    }

    /// Returns matched candidates only on the frame that fulfilled a capture request, else nil.
    func process(_ pixelBuffer: CVPixelBuffer) -> [Candidate]? {
        let (currentMatcher, isCapture) = state.withLock { state -> (CardScanMatching?, Bool) in
            let capture = state.captureRequested
            state.captureRequested = false
            return (state.matcher, capture)
        }

        guard isCapture, let crop = centerCardCrop(pixelBuffer) else {
            return isCapture ? [] : nil
        }
        return [Candidate(crop: crop, matches: currentMatcher?.matches(crop, limit: 8) ?? [])]
    }

    /// Crops the centered card-aspect region that matches the on-screen guide.
    private func centerCardCrop(_ pixelBuffer: CVPixelBuffer) -> CGImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let extent = ciImage.extent
        guard extent.width > 0, extent.height > 0 else { return nil }

        var height = extent.height * 0.88
        var width = height * Self.cardAspect
        if width > extent.width * 0.92 {
            width = extent.width * 0.92
            height = width / Self.cardAspect
        }
        let rect = CGRect(x: extent.midX - width / 2, y: extent.midY - height / 2, width: width, height: height)
        return ciContext.createCGImage(ciImage, from: rect)
    }
}
