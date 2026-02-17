//
//  ImageSlideshowWrapper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import SwiftUI
import UIKit

struct ImageSlideshowWrapper: UIViewRepresentable {
    let imageInputs: [InputSource]
    let currentIndex: Int
    let onPageChanged: (Int) -> Void
    let onImageTapped: () -> Void

    func makeUIView(context: Context) -> ImageSlideshow {
        let slideshow = ImageSlideshow()

        slideshow.backgroundColor = UIColor.systemBackground
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.pageIndicator = nil
        slideshow.circular = false
        slideshow.preload = .fixed(offset: 1)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.imageTapped))
        slideshow.addGestureRecognizer(tapGesture)

        slideshow.delegate = context.coordinator

        return slideshow
    }

    func updateUIView(_ uiView: ImageSlideshow, context: Context) {
        if uiView.images.count != imageInputs.count {
            uiView.setImageInputs(imageInputs)
        }

        if uiView.currentPage != currentIndex {
            uiView.setCurrentPage(currentIndex, animated: true)
        }

        context.coordinator.onPageChanged = onPageChanged
        context.coordinator.onImageTapped = onImageTapped
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onPageChanged: onPageChanged, onImageTapped: onImageTapped)
    }

    class Coordinator: NSObject, ImageSlideshowDelegate {
        var onPageChanged: (Int) -> Void
        var onImageTapped: () -> Void

        init(onPageChanged: @escaping (Int) -> Void, onImageTapped: @escaping () -> Void) {
            self.onPageChanged = onPageChanged
            self.onImageTapped = onImageTapped
        }

        func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
            onPageChanged(page)
        }

        @objc
        func imageTapped() {
            onImageTapped()
        }
    }
}

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

#Preview {
    let sampleCard = CardDTO()
    sampleCard.name = "Sample Card"
    sampleCard.imageUrl = "https://example.com/card.jpg"

    let imageInputs = [ImageSource(image: Asset.icCardback.image)]

    return ImageSlideshowWrapper(
        imageInputs: imageInputs,
        currentIndex: 0,
        onPageChanged: { _ in },
        onImageTapped: {}
    )
    .frame(height: 400)
}
