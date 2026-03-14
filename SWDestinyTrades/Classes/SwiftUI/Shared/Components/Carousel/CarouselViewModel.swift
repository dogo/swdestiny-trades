//
//  CarouselViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import UIKit

/// Manages carousel state: current page, auto-scroll timer, image load states, and preloading logic.
/// Follows the existing `@Observable` pattern used throughout the codebase.
@MainActor
@Observable
final class CarouselViewModel {

    // MARK: - Public State

    private(set) var currentPage: Int = 0
    private(set) var imageStates: [ImageSource: ImageLoadState] = [:]
    var isAutoScrolling: Bool = false

    // MARK: - Configuration

    let items: [ImageSource]
    let autoScrollInterval: TimeInterval?
    let isCircular: Bool
    let preloadOffset: Int

    // MARK: - Dependencies

    private let imageLoader: ImageLoadingService

    // MARK: - Internal State

    private var autoScrollTask: Task<Void, Never>?
    var loadTasks: [ImageSource: Task<Void, Never>] = [:]

    var pageCount: Int {
        items.count
    }

    // MARK: - Init

    init(
        items: [ImageSource],
        imageLoader: ImageLoadingService,
        autoScrollInterval: TimeInterval? = nil,
        isCircular: Bool = false,
        preloadOffset: Int = 1
    ) {
        self.items = items
        self.imageLoader = imageLoader
        self.autoScrollInterval = autoScrollInterval
        self.isCircular = isCircular
        self.preloadOffset = preloadOffset
    }

    // MARK: - Page Navigation

    func setPage(_ page: Int) {
        guard page >= 0, page < pageCount else { return }
        currentPage = page
        prefetchAdjacentPages()
        resetAutoScrollIfNeeded()
    }

    func advanceToNextPage() {
        if currentPage < pageCount - 1 {
            currentPage += 1
        } else if isCircular {
            currentPage = 0
        }
        prefetchAdjacentPages()
    }

    func advanceToPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
        } else if isCircular {
            currentPage = pageCount - 1
        }
        prefetchAdjacentPages()
    }

    // MARK: - Image Loading

    func loadImage(for source: ImageSource, placeholder: UIImage?) {
        guard loadTasks[source] == nil else { return }
        imageStates[source] = .loading(progress: 0)
        loadTasks[source] = Task { [weak self] in
            guard let self else { return }
            do {
                let image = try await imageLoader.loadImage(
                    from: source,
                    placeholder: placeholder
                ) { [weak self] progress in
                    Task { @MainActor [weak self] in
                        self?.imageStates[source] = .loading(progress: progress)
                    }
                }
                imageStates[source] = .loaded(image)
            } catch {
                imageStates[source] = .failed(error)
            }
            loadTasks[source] = nil
        }
    }

    func retryLoad(for source: ImageSource, placeholder: UIImage?) {
        loadTasks[source]?.cancel()
        loadTasks[source] = nil
        imageStates[source] = .idle
        loadImage(for: source, placeholder: placeholder)
    }

    // MARK: - Auto-Scroll

    func startAutoScroll() {
        guard let interval = autoScrollInterval, pageCount > 1 else { return }
        isAutoScrolling = true
        autoScrollTask?.cancel()
        autoScrollTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard !Task.isCancelled else { break }
                self?.advanceToNextPage()
            }
        }
    }

    func stopAutoScroll() {
        isAutoScrolling = false
        autoScrollTask?.cancel()
        autoScrollTask = nil
    }

    func resetAutoScrollIfNeeded() {
        guard autoScrollInterval != nil, isAutoScrolling else { return }
        stopAutoScroll()
        startAutoScroll()
    }

    // MARK: - Prefetch

    func prefetchAdjacentPages() {
        guard pageCount > 0 else { return }

        let indicesToPrefetch = (-preloadOffset ... preloadOffset).compactMap { offset -> Int? in
            let index = currentPage + offset
            if isCircular {
                return ((index % pageCount) + pageCount) % pageCount
            }
            return (index >= 0 && index < pageCount) ? index : nil
        }

        let sourcesToPrefetch = indicesToPrefetch.map { items[$0] }
        imageLoader.prefetch(sources: sourcesToPrefetch)
    }

    // MARK: - Cleanup

    func cancelAllLoads() {
        loadTasks.values.forEach { $0.cancel() }
        loadTasks.removeAll()
        stopAutoScroll()
    }
}
