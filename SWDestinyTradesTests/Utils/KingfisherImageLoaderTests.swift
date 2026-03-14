//
//  KingfisherImageLoaderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class KingfisherImageLoaderTests: XCTestCase {

    // MARK: - Properties

    private var sut: KingfisherImageLoader!

    // MARK: - Lifecycle

    override func setUp() async throws {
        try await super.setUp()
        sut = KingfisherImageLoader()
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - loadImage Tests

    func test_loadLocalImage_returnsSameInstance() async throws {
        let originalImage = UIImage()

        let result = try await sut.loadImage(from: .local(originalImage), placeholder: nil, onProgress: nil)

        XCTAssertTrue(result === originalImage, "Loading a local image should return the exact same instance")
    }

    func test_loadLocalImage_ignoresPlaceholder() async throws {
        let originalImage = UIImage()
        let placeholder = UIImage()

        let result = try await sut.loadImage(from: .local(originalImage), placeholder: placeholder, onProgress: nil)

        XCTAssertTrue(result === originalImage, "Should return the original image, not the placeholder")
        XCTAssertFalse(result === placeholder, "Should not return the placeholder image")
    }

    func test_loadAsset_throwsAssetNotFound_forInvalidName() async {
        do {
            _ = try await sut.loadImage(from: .asset("nonexistent_xyz"), placeholder: nil, onProgress: nil)
            XCTFail("Expected ImageLoadError.assetNotFound to be thrown")
        } catch let error as ImageLoadError {
            XCTAssertEqual(error, ImageLoadError.assetNotFound("nonexistent_xyz"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_loadAsset_errorDescription_containsAssetName() async {
        do {
            _ = try await sut.loadImage(from: .asset("missing_icon"), placeholder: nil, onProgress: nil)
            XCTFail("Expected ImageLoadError.assetNotFound to be thrown")
        } catch let error as ImageLoadError {
            XCTAssertNotNil(error.errorDescription)
            XCTAssertTrue(error.errorDescription?.contains("missing_icon") == true, "Error description should contain the asset name")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_loadLocalImage_doesNotInvokeProgressCallback() async throws {
        var progressCallCount = 0
        let originalImage = UIImage()

        _ = try await sut.loadImage(from: .local(originalImage), placeholder: nil) { _ in
            progressCallCount += 1
        }

        XCTAssertEqual(progressCallCount, 0, "Progress callback should never be invoked for local images")
    }

    // MARK: - Protocol Conformance

    func test_conformsToImageLoadingService() {
        let service: any ImageLoadingService = sut
        XCTAssertNotNil(service)
    }

    // MARK: - clearMemoryCache Tests

    func test_clearMemoryCache_completesWithoutError() async throws {
        sut.clearMemoryCache()

        let image = UIImage()
        let result = try await sut.loadImage(from: .local(image), placeholder: nil, onProgress: nil)

        XCTAssertTrue(result === image, "Should still be able to load images after clearing the cache")
    }
}
