//
//  FullScreenImageViewer.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import SwiftUI

struct FullScreenImageViewer: View {
    let imageInputs: [InputSource]
    let initialIndex: Int
    @Binding var isPresented: Bool

    @State private var currentIndex: Int
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    init(imageInputs: [InputSource], initialIndex: Int, isPresented: Binding<Bool>) {
        self.imageInputs = imageInputs
        self.initialIndex = initialIndex
        _isPresented = isPresented
        _currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                if let imageInput = imageInputs[safe: currentIndex] {
                    AsyncImageView(imageInput: imageInput) { image in
                        shareImage = image
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.done) {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if shareImage != nil {
                            showingShareSheet = true
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(shareImage == nil)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let shareImage {
                    ShareSheet(items: [shareImage])
                }
            }
        }
    }
}

struct AsyncImageView: UIViewRepresentable {
    let imageInput: InputSource
    let onImageLoaded: (UIImage) -> Void

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        imageInput.load(to: uiView) { image in
            if let image {
                onImageLoaded(image)
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
