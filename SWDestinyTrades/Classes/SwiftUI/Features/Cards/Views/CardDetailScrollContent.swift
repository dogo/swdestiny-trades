//
//  CardDetailScrollContent.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardDetailScrollContent: View {
    @Bindable var viewModel: CardDetailViewModel
    let showAddToCollection: Bool

    @State private var fullScreenSource: ImageSource?
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CarouselView(
                    items: viewModel.imageSources,
                    imageLoader: viewModel.imageLoader,
                    currentPage: $viewModel.currentIndex,
                    currentImage: $shareImage,
                    placeholder: Asset.icCardback.image,
                    showsPageIndicator: false
                ) { index in
                    guard index < viewModel.imageSources.count else { return }
                    fullScreenSource = viewModel.imageSources[index]
                }
                .frame(height: 400)

                CardInfoSection(card: viewModel.currentCard)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(L10n.share, systemImage: "square.and.arrow.up") {
                    showingShareSheet = true
                }
                .disabled(shareImage == nil)

                if showAddToCollection {
                    Button {
                        Task {
                            await viewModel.addToCollection()
                        }
                    } label: {
                        Image(asset: Asset.NavigationBar.icAddCollection)
                    }
                    .accessibilityLabel(L10n.addToCollection)
                }
            }
        }
        .sheet(item: $fullScreenSource) { source in
            FullScreenCarouselViewer(
                source: source,
                imageLoader: viewModel.imageLoader
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareImage {
                ShareSheet(items: [shareImage])
            }
        }
    }
}
