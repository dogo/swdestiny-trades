//
//  FullScreenCarouselViewer.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

private struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

/// A full-screen image viewer with share and dismiss controls.
struct FullScreenCarouselViewer: View {
    let source: ImageSource
    let imageLoader: ImageLoadingService
    @Environment(\.dismiss) private var dismiss

    @State private var shareItem: IdentifiableImage?
    @State private var loadedImage: UIImage?

    var body: some View {
        NavigationStack {
            imageContent
                .background(Color.black)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(L10n.done) { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(L10n.share, systemImage: "square.and.arrow.up") {
                            shareItem = loadedImage.map { IdentifiableImage(image: $0) }
                        }
                        .disabled(loadedImage == nil)
                    }
                }
                .sheet(item: $shareItem) { item in
                    ShareSheet(items: [item.image])
                }
                .task {
                    await loadImage()
                }
        }
    }

    @ViewBuilder private var imageContent: some View {
        if let loadedImage {
            Image(uiImage: loadedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func loadImage() async {
        do {
            loadedImage = try await imageLoader.loadImage(
                from: source,
                placeholder: nil,
                onProgress: nil
            )
        } catch {
            loadedImage = nil
        }
    }
}
