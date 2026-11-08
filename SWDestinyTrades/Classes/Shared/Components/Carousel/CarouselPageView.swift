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
            CarouselPageContentView(
                state: state,
                placeholder: placeholder,
                errorImage: errorImage,
                onRetry: onRetry
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .clipped()
        .contentShape(Rectangle())
    }
}
