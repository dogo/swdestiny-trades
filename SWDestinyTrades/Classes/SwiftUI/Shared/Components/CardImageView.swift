//
//  CardImageView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 22/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

/// A reusable card thumbnail that loads its image through `ImageLoadingService`, reusing the
/// same caching abstraction as the carousel (backed by `KingfisherImageLoader`).
///
/// Loading goes through the shared image cache, so a card image already fetched elsewhere
/// (list, search, detail, carousel) is served instantly without re-downloading — including when
/// navigating back to a list.
///
/// The loader is resolved from the environment `DependencyContainer` by default; previews and
/// tests can inject a custom `ImageLoadingService` (e.g. `MockImageLoader`).
struct CardImageView: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let showsBorder: Bool

    private let injectedLoader: ImageLoadingService?

    @Environment(\.dependencyContainer) private var dependencyContainer
    @State private var state: ImageLoadState = .idle

    init(
        imageUrl: String,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat,
        showsBorder: Bool = false,
        imageLoader: ImageLoadingService? = nil
    ) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.showsBorder = showsBorder
        injectedLoader = imageLoader
    }

    var body: some View {
        content
            .frame(width: width, height: height)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                if showsBorder {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                }
            }
            .task(id: imageUrl) {
                await loadImage()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case let .loaded(image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .failed:
            cardback(opacity: 0.5)
        case .idle, .loading:
            ZStack {
                cardback(opacity: 0.3)
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }

    private func cardback(opacity: Double) -> some View {
        Image(asset: Asset.icCardback)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(opacity)
    }

    private var imageLoader: ImageLoadingService {
        injectedLoader ?? dependencyContainer.resolve(type: ImageLoadingService.self)
    }

    private func loadImage() async {
        guard let url = URL(string: imageUrl) else {
            state = .failed(ImageLoadError.invalidURL)
            return
        }

        state = .loading(progress: 0)

        do {
            let image = try await imageLoader.loadImage(from: .remote(url), placeholder: nil, onProgress: nil)
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
}
