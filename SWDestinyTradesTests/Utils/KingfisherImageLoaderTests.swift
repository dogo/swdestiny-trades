//
//  KingfisherImageLoaderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Testing
import UIKit

@testable import SWDestinyTrades

@MainActor
final class KingfisherImageLoaderTests {

    // MARK: - Properties

    private var sut: KingfisherImageLoader!

    // MARK: - Lifecycle

    init() async throws {
        sut = KingfisherImageLoader()
    }

    isolated deinit {
        sut = nil
    }

    // MARK: - loadImage Tests

    @Test
    func loadLocalImage_returnsSameInstance() async throws {
        let originalImage = UIImage()

        let result = try await sut.loadImage(from: .local(originalImage), placeholder: nil, onProgress: nil)

        #expect(result === originalImage, "Loading a local image should return the exact same instance")
    }

    @Test
    func loadLocalImage_ignoresPlaceholder() async throws {
        let originalImage = UIImage()
        let placeholder = UIImage()

        let result = try await sut.loadImage(from: .local(originalImage), placeholder: placeholder, onProgress: nil)

        #expect(result === originalImage, "Should return the original image, not the placeholder")
        #expect(result !== placeholder, "Should not return the placeholder image")
    }

    @Test
    func loadAsset_throwsAssetNotFound_forInvalidName() async {
        do {
            _ = try await sut.loadImage(from: .asset("nonexistent_xyz"), placeholder: nil, onProgress: nil)
            Issue.record("Expected ImageLoadError.assetNotFound to be thrown")
        } catch let error as ImageLoadError {
            #expect(error == ImageLoadError.assetNotFound("nonexistent_xyz"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test
    func loadAsset_errorDescription_containsAssetName() async {
        do {
            _ = try await sut.loadImage(from: .asset("missing_icon"), placeholder: nil, onProgress: nil)
            Issue.record("Expected ImageLoadError.assetNotFound to be thrown")
        } catch let error as ImageLoadError {
            #expect(error.errorDescription != nil)
            #expect(error.errorDescription?.contains("missing_icon") == true, "Error description should contain the asset name")
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test
    func loadLocalImage_doesNotInvokeProgressCallback() async throws {
        var progressCallCount = 0
        let originalImage = UIImage()

        _ = try await sut.loadImage(from: .local(originalImage), placeholder: nil) { @MainActor _ in
            progressCallCount += 1
        }

        #expect(progressCallCount == 0, "Progress callback should never be invoked for local images")
    }

    // MARK: - Protocol Conformance

    @Test
    func conformsToImageLoadingService() {
        let service: any ImageLoadingService = sut
        #expect((service as? KingfisherImageLoader) === sut)
    }

    // MARK: - clearMemoryCache Tests

    @Test
    func clearMemoryCache_completesWithoutError() async throws {
        sut.clearMemoryCache()

        let image = UIImage()
        let result = try await sut.loadImage(from: .local(image), placeholder: nil, onProgress: nil)

        #expect(result === image, "Should still be able to load images after clearing the cache")
    }
}
