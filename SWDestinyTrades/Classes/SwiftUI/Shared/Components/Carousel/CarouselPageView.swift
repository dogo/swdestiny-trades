//
//  CarouselPageView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// Renders a single page of the carousel based on the current `ImageLoadState`.
struct CarouselPageView: View {
    let source: ImageSource
    let state: ImageLoadState
    let placeholder: UIImage?
    let errorImage: UIImage?
    let onRetry: () -> Void

    var body: some View {
        GeometryReader { geometry in
            contentView
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .clipped()
        .contentShape(Rectangle())
    }

    @ViewBuilder private var contentView: some View {
        switch state {
        case .idle:
            placeholderView

        case let .loading(progress):
            ZStack {
                placeholderView
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(.circular)
            }

        case let .loaded(image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)

        case .failed:
            VStack(spacing: 12) {
                if let errorImage {
                    Image(uiImage: errorImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
                Button("Retry") { onRetry() }
                    .buttonStyle(.bordered)
            }
        }
    }

    @ViewBuilder private var placeholderView: some View {
        if let placeholder {
            Image(uiImage: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color(.systemGray6)
        }
    }
}
