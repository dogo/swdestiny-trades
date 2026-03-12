//
//  FullScreenCarouselViewer.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// A full-screen image viewer with share and dismiss controls.
struct FullScreenCarouselViewer: View {
    let source: ImageSource
    let imageLoader: ImageLoadingService
    @Binding var isPresented: Bool

    @State private var showingShareSheet = false
    @State private var loadedImage: UIImage?

    var body: some View {
        NavigationStack {
            Group {
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
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.done) { isPresented = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if loadedImage != nil { showingShareSheet = true }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(loadedImage == nil)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let loadedImage {
                    ShareSheet(items: [loadedImage])
                }
            }
            .task {
                await loadImage()
            }
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
