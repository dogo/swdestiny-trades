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
