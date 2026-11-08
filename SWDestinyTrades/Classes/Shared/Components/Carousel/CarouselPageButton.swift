//
//  CarouselPageButton.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CarouselPageButton: View {
    let index: Int
    let source: ImageSource
    let state: ImageLoadState
    let placeholder: UIImage?
    let errorImage: UIImage?
    let showAsButton: Bool
    let onTap: () -> Void
    let onLoad: () -> Void
    let onRetry: () -> Void

    var body: some View {
        Button(action: onTap) {
            CarouselPageView(
                source: source,
                state: state,
                placeholder: placeholder,
                errorImage: errorImage,
                onRetry: onRetry
            )
        }
        .buttonStyle(.plain)
        .tag(index)
        .accessibilityAddTraits(showAsButton ? .isButton : [])
        .onAppear(perform: onLoad)
    }
}
