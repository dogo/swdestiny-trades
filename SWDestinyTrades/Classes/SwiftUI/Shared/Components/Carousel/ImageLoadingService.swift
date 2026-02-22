//
//  ImageLoadingService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import UIKit

/// The core abstraction for image loading. All carousel image operations go through this protocol.
///
/// This protocol decouples the carousel from any specific image loading library (e.g., Kingfisher),
/// enabling full dependency injection for testing and allowing the underlying implementation to be
/// swapped without affecting consumers.
@MainActor
protocol ImageLoadingService: Sendable {

    /// Loads an image from the given source.
    /// - Parameters:
    ///   - source: The image source (remote URL, local image, or asset name).
    ///   - placeholder: Optional placeholder image shown during loading.
    ///   - onProgress: Optional progress callback (0.0 to 1.0) for download tracking.
    /// - Returns: The loaded UIImage.
    /// - Throws: `ImageLoadError` if loading fails.
    func loadImage(
        from source: ImageSource,
        placeholder: UIImage?,
        onProgress: (@Sendable (Double) -> Void)?
    ) async throws -> UIImage

    /// Cancels any in-flight loading for the given source.
    func cancelLoad(for source: ImageSource)

    /// Prefetches images for the given sources (used for preloading adjacent pages).
    func prefetch(sources: [ImageSource])

    /// Cancels prefetch for the given sources.
    func cancelPrefetch(sources: [ImageSource])

    /// Clears the in-memory image cache. Disk cache is managed by the implementation's own eviction policy.
    func clearMemoryCache()
}
