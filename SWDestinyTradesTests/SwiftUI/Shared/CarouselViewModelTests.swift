//
//  CarouselViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing
import UIKit

@testable import SWDestinyTrades

@MainActor
final class CarouselViewModelTests: BaseTestCase {

    private let loader = MockImageLoader()
    private let sources: [ImageSource] = [.asset("a"), .asset("b"), .asset("c")]

    private func makeSUT(
        items: [ImageSource]? = nil,
        autoScrollInterval: TimeInterval? = nil,
        isCircular: Bool = false
    ) -> CarouselViewModel {
        CarouselViewModel(
            items: items ?? sources,
            imageLoader: loader,
            autoScrollInterval: autoScrollInterval,
            isCircular: isCircular
        )
    }

    // MARK: - Navigation

    @Test
    func advanceToNextPage_linear_stopsAtLastPage() {
        let sut = makeSUT()

        sut.advanceToNextPage()
        sut.advanceToNextPage()
        sut.advanceToNextPage()

        #expect(sut.currentPage == 2)
    }

    @Test
    func advanceToNextPage_circular_wrapsToFirstPage() {
        let sut = makeSUT(isCircular: true)
        sut.setPage(2)

        sut.advanceToNextPage()

        #expect(sut.currentPage == 0)
    }

    @Test
    func advanceToPreviousPage_linear_stopsAtFirstPage() {
        let sut = makeSUT()

        sut.advanceToPreviousPage()

        #expect(sut.currentPage == 0)
    }

    @Test
    func advanceToPreviousPage_circular_wrapsToLastPage() {
        let sut = makeSUT(isCircular: true)

        sut.advanceToPreviousPage()

        #expect(sut.currentPage == 2)
    }

    @Test(arguments: [-1, 3])
    func setPage_outOfRange_isIgnored(page: Int) {
        let sut = makeSUT()

        sut.setPage(page)

        #expect(sut.currentPage == 0)
        #expect(loader.prefetchedSources.isEmpty)
    }

    // MARK: - Prefetch

    @Test
    func setPage_prefetchesNeighbours() {
        let sut = makeSUT()

        sut.setPage(1)

        #expect(loader.prefetchedSources == sources)
    }

    @Test
    func prefetch_linear_atFirstPage_skipsMissingNeighbour() {
        let sut = makeSUT()

        sut.prefetchAdjacentPages()

        #expect(loader.prefetchedSources == [.asset("a"), .asset("b")])
    }

    @Test
    func prefetch_circular_atFirstPage_wrapsToLastPage() {
        let sut = makeSUT(isCircular: true)

        sut.prefetchAdjacentPages()

        #expect(loader.prefetchedSources == [.asset("c"), .asset("a"), .asset("b")])
    }

    @Test
    func prefetch_withNoItems_doesNothing() {
        let sut = makeSUT(items: [])

        sut.prefetchAdjacentPages()

        #expect(loader.prefetchedSources.isEmpty)
    }

    // MARK: - Image loading

    @Test
    func loadImage_success_endsLoaded() async {
        let image = UIImage()
        loader.stubbedImage = image
        let sut = makeSUT()

        sut.loadImage(for: .asset("a"), placeholder: nil)
        #expect(sut.imageStates[.asset("a")] == .loading(progress: 0))
        await waitUntil { sut.loadTasks.isEmpty }

        #expect(sut.imageStates[.asset("a")] == .loaded(image))
    }

    @Test
    func loadImage_failure_endsFailed() async {
        loader.stubbedError = ImageLoadError.assetNotFound("a")
        let sut = makeSUT()

        sut.loadImage(for: .asset("a"), placeholder: nil)
        await waitUntil { sut.loadTasks.isEmpty }

        guard case let .failed(error) = sut.imageStates[.asset("a")] else {
            Issue.record("Expected a failed state, got \(String(describing: sut.imageStates[.asset("a")]))")
            return
        }
        #expect(error as? ImageLoadError == .assetNotFound("a"))
    }

    @Test
    func loadImage_whileInFlight_doesNotStartSecondLoad() async {
        let sut = makeSUT()

        sut.loadImage(for: .asset("a"), placeholder: nil)
        sut.loadImage(for: .asset("a"), placeholder: nil)
        await waitUntil { sut.loadTasks.isEmpty }

        #expect(loader.loadImageCallCount == 1)
    }

    @Test
    func retryLoad_startsANewLoad() async {
        let sut = makeSUT()
        sut.loadImage(for: .asset("a"), placeholder: nil)
        await waitUntil { sut.loadTasks.isEmpty }

        sut.retryLoad(for: .asset("a"), placeholder: nil)
        await waitUntil { sut.loadTasks.isEmpty }

        #expect(loader.loadImageCallCount == 2)
    }

    // MARK: - Auto-scroll

    @Test
    func startAutoScroll_withoutInterval_doesNothing() {
        let sut = makeSUT()

        sut.startAutoScroll()

        #expect(sut.isAutoScrolling == false)
    }

    @Test
    func startAutoScroll_withSinglePage_doesNothing() {
        let sut = makeSUT(items: [.asset("a")], autoScrollInterval: 0.01)

        sut.startAutoScroll()

        #expect(sut.isAutoScrolling == false)
    }

    @Test
    func startAutoScroll_advancesPages() async {
        let sut = makeSUT(autoScrollInterval: 0.01)

        sut.startAutoScroll()
        await waitUntil { sut.currentPage == 1 }
        sut.stopAutoScroll()

        #expect(sut.currentPage >= 1)
        #expect(sut.isAutoScrolling == false)
    }

    @Test
    func cancelAllLoads_clearsTasksAndStopsAutoScroll() {
        let sut = makeSUT(autoScrollInterval: 10)
        sut.startAutoScroll()
        sut.loadImage(for: .asset("a"), placeholder: nil)

        sut.cancelAllLoads()

        #expect(sut.loadTasks.isEmpty)
        #expect(sut.isAutoScrolling == false)
    }

    // MARK: - Models

    @Test
    func imageLoadState_equality() {
        let image = UIImage()
        #expect(ImageLoadState.idle == .idle)
        #expect(ImageLoadState.loading(progress: 0.5) == .loading(progress: 0.5))
        #expect(ImageLoadState.loading(progress: 0.5) != .loading(progress: 0.6))
        #expect(ImageLoadState.loaded(image) == .loaded(image))
        #expect(ImageLoadState.loaded(image) != .loaded(UIImage()))
        #expect(ImageLoadState.failed(ImageLoadError.cancelled) == .failed(ImageLoadError.cancelled))
        #expect(ImageLoadState.idle != .loading(progress: 0))
    }

    @Test
    func imageLoadError_descriptions() {
        #expect(ImageLoadError.invalidURL.errorDescription == "The image URL is invalid.")
        #expect(ImageLoadError.assetNotFound("x").errorDescription == "Asset 'x' not found in bundle.")
        #expect(ImageLoadError.cancelled.errorDescription == "Image loading was cancelled.")
        #expect(ImageLoadError.unknown("boom").errorDescription == "boom")
        #expect(ImageLoadError.networkError(URLError(.timedOut)).errorDescription?.hasPrefix("Network error: ") == true)
        #expect(ImageLoadError.cancelled == .cancelled)
        #expect(ImageLoadError.cancelled != .invalidURL)
    }
}
