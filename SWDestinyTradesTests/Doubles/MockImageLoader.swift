//
//  MockImageLoader.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import UIKit

@testable import SWDestinyTrades

@MainActor
final class MockImageLoader: ImageLoadingService {

    var loadImageCallCount = 0
    var lastLoadedSource: ImageSource?
    var stubbedImage: UIImage = .init()
    var stubbedError: Error?
    var prefetchedSources: [ImageSource] = []
    var cancelledSources: [ImageSource] = []

    func loadImage(
        from source: ImageSource,
        placeholder: UIImage?,
        onProgress: (@MainActor @Sendable (Double) -> Void)?
    ) async throws -> UIImage {
        loadImageCallCount += 1
        lastLoadedSource = source
        if let error = stubbedError { throw error }
        onProgress?(1.0)
        return stubbedImage
    }

    func cancelLoad(for source: ImageSource) {
        cancelledSources.append(source)
    }

    func prefetch(sources: [ImageSource]) {
        prefetchedSources.append(contentsOf: sources)
    }

    func cancelPrefetch(sources: [ImageSource]) {}

    func clearMemoryCache() {}
}
