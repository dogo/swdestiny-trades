//
//  CarouselView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// The primary SwiftUI carousel view that renders a paginated image carousel with optional
/// page indicators, auto-scroll, prefetching, and tap handling.
///
/// Accepts an `ImageLoadingService` as an explicit init parameter for dependency injection,
/// enabling full testability without requiring the `DependencyContainer`.
struct CarouselView: View {
    @State private var viewModel: CarouselViewModel
    @Binding var currentPage: Int

    let placeholder: UIImage?
    let errorImage: UIImage?
    let showsPageIndicator: Bool
    let pageIndicatorStyle: CarouselPageIndicatorStyle
    let onItemTapped: ((Int) -> Void)?

    /// Primary initializer for image-based carousel.
    /// - Parameters:
    ///   - items: The image sources to display in the carousel.
    ///   - imageLoader: The image loading service used to load, prefetch, and cancel images.
    ///   - currentPage: A binding to the current page index.
    ///   - placeholder: Optional placeholder image shown while loading.
    ///   - errorImage: Optional error image shown when loading fails.
    ///   - autoScrollInterval: Optional interval for automatic page advancement.
    ///   - isCircular: Whether the carousel wraps around at boundaries.
    ///   - preloadOffset: Number of adjacent pages to prefetch.
    ///   - showsPageIndicator: Whether to show the page indicator dots.
    ///   - pageIndicatorStyle: Style configuration for the page indicator.
    ///   - onItemTapped: Callback invoked when a carousel page is tapped.
    init(
        items: [ImageSource],
        imageLoader: ImageLoadingService,
        currentPage: Binding<Int> = .constant(0),
        placeholder: UIImage? = nil,
        errorImage: UIImage? = nil,
        autoScrollInterval: TimeInterval? = nil,
        isCircular: Bool = false,
        preloadOffset: Int = 1,
        showsPageIndicator: Bool = true,
        pageIndicatorStyle: CarouselPageIndicatorStyle = .default,
        onItemTapped: ((Int) -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: CarouselViewModel(
            items: items,
            imageLoader: imageLoader,
            autoScrollInterval: autoScrollInterval,
            isCircular: isCircular,
            preloadOffset: preloadOffset
        ))
        _currentPage = currentPage
        self.placeholder = placeholder
        self.errorImage = errorImage
        self.showsPageIndicator = showsPageIndicator
        self.pageIndicatorStyle = pageIndicatorStyle
        self.onItemTapped = onItemTapped
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, source in
                    CarouselPageView(
                        source: source,
                        state: viewModel.imageStates[source] ?? .idle,
                        placeholder: placeholder,
                        errorImage: errorImage,
                        onRetry: { viewModel.retryLoad(for: source, placeholder: placeholder) }
                    )
                    .tag(index)
                    .onTapGesture { onItemTapped?(index) }
                    .onAppear { viewModel.loadImage(for: source, placeholder: placeholder) }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onChange(of: currentPage) { _, newValue in
                viewModel.setPage(newValue)
            }

            if showsPageIndicator, viewModel.pageCount > 1 {
                CarouselPageIndicator(
                    pageCount: viewModel.pageCount,
                    currentPage: $currentPage,
                    style: pageIndicatorStyle
                )
                .padding(.top, 8)
            }
        }
        .onAppear {
            viewModel.prefetchAdjacentPages()
            if viewModel.autoScrollInterval != nil {
                viewModel.startAutoScroll()
            }
        }
        .onDisappear {
            viewModel.cancelAllLoads()
        }
    }
}
