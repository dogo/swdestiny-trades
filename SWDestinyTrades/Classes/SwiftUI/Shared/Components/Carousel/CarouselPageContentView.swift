//
//  CarouselPageContentView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CarouselPageContentView: View {
    let state: ImageLoadState
    let placeholder: UIImage?
    let errorImage: UIImage?
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .idle:
            CarouselPlaceholderView(placeholder: placeholder)

        case let .loading(progress):
            ZStack {
                CarouselPlaceholderView(placeholder: placeholder)
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(.circular)
            }

        case let .loaded(image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .accessibilityHidden(true)

        case .failed:
            VStack(spacing: 12) {
                if let errorImage {
                    Image(uiImage: errorImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)
                        .accessibilityHidden(true)
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                Button(L10n.retry, action: onRetry)
                    .buttonStyle(.bordered)
            }
        }
    }
}
