//
//  KingfisherImageLoader.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Kingfisher
import UIKit

final class KingfisherImageLoader: ImageLoadingService {

    private let downloader: ImageDownloader
    private let cache: ImageCache
    private let retryStrategy: DelayRetryStrategy

    init(
        downloader: ImageDownloader = .default,
        cache: ImageCache = .default,
        maxRetryCount: Int = 2,
        retryInterval: DelayRetryStrategy.Interval = .seconds(1)
    ) {
        self.downloader = downloader
        self.cache = cache
        retryStrategy = DelayRetryStrategy(
            maxRetryCount: maxRetryCount,
            retryInterval: retryInterval
        )
    }

    func loadImage(
        from source: ImageSource,
        placeholder: UIImage?,
        onProgress: (@Sendable (Double) -> Void)?
    ) async throws -> UIImage {
        switch source {
        case let .remote(url):
            return try await loadRemoteImage(url: url, onProgress: onProgress)
        case let .local(image):
            return image
        case let .asset(name):
            guard let image = UIImage(named: name) else {
                throw ImageLoadError.assetNotFound(name)
            }
            return image
        }
    }

    func cancelLoad(for source: ImageSource) {
        guard case let .remote(url) = source else { return }
        downloader.cancel(url: url)
    }

    func prefetch(sources: [ImageSource]) {
        let urls = sources.compactMap { source -> URL? in
            guard case let .remote(url) = source else { return nil }
            return url
        }
        guard !urls.isEmpty else { return }
        ImagePrefetcher(urls: urls).start()
    }

    func cancelPrefetch(sources: [ImageSource]) {
        let urls = sources.compactMap { source -> URL? in
            guard case let .remote(url) = source else { return nil }
            return url
        }
        guard !urls.isEmpty else { return }
        ImagePrefetcher(urls: urls).stop()
    }

    func clearMemoryCache() {
        cache.clearMemoryCache()
    }

    // MARK: - Private

    private func loadRemoteImage(
        url: URL,
        onProgress: (@Sendable (Double) -> Void)?
    ) async throws -> UIImage {
        let resource = ImageResource(downloadURL: url)
        let options: KingfisherOptionsInfo = [
            .targetCache(cache),
            .retryStrategy(retryStrategy),
            .transition(.fade(0.2)),
            .cacheOriginalImage,
            .backgroundDecode
        ]

        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(
                with: resource,
                options: options,
                progressBlock: { received, total in
                    guard total > 0 else { return }
                    let progress = Double(received) / Double(total)
                    onProgress?(progress)
                },
                completionHandler: { result in
                    switch result {
                    case let .success(value):
                        continuation.resume(returning: value.image)
                    case let .failure(error):
                        continuation.resume(throwing: ImageLoadError.networkError(error))
                    }
                }
            )
        }
    }
}
