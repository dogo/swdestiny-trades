//
//  CarouselPageIndicator.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// A customizable dot-based page indicator for the carousel.
struct CarouselPageIndicator: View {
    let pageCount: Int
    @Binding var currentPage: Int
    let style: CarouselPageIndicatorStyle

    var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(0 ..< pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? style.activeColor : style.inactiveColor)
                    .frame(width: style.dotSize, height: style.dotSize)
                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                    .onTapGesture { currentPage = index }
                    .accessibilityLabel("Page \(index + 1) of \(pageCount)")
                    .accessibilityAddTraits(index == currentPage ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Page indicator")
    }
}
