//
//  CarouselModels.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - ImageSource

/// Represents the source of an image to be loaded by the carousel.
enum ImageSource: Hashable, Sendable {
    case remote(URL)
    case local(UIImage)
    case asset(String)
}

// MARK: - ImageLoadState

/// Represents the loading state of a single image.
enum ImageLoadState: Equatable {
    case idle
    case loading(progress: Double)
    case loaded(UIImage)
    case failed(Error)

    static func == (lhs: ImageLoadState, rhs: ImageLoadState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.loading(lhsProgress), .loading(rhsProgress)):
            return lhsProgress == rhsProgress
        case let (.loaded(lhsImage), .loaded(rhsImage)):
            return lhsImage === rhsImage
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

// MARK: - ImageLoadError

/// Typed errors for image loading failures.
enum ImageLoadError: Error, LocalizedError, Equatable {
    case invalidURL
    case networkError(Error)
    case assetNotFound(String)
    case cancelled
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The image URL is invalid."
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .assetNotFound(name):
            return "Asset '\(name)' not found in bundle."
        case .cancelled:
            return "Image loading was cancelled."
        case let .unknown(message):
            return message
        }
    }

    static func == (lhs: ImageLoadError, rhs: ImageLoadError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}

// MARK: - CarouselPageIndicatorStyle

/// Customizable style for the carousel page indicator dots.
struct CarouselPageIndicatorStyle: Equatable {
    var activeColor: Color
    var inactiveColor: Color
    var dotSize: CGFloat
    var spacing: CGFloat

    static let `default` = CarouselPageIndicatorStyle(
        activeColor: .primary,
        inactiveColor: .secondary.opacity(0.4),
        dotSize: 8,
        spacing: 8
    )
}

// MARK: - CarouselConfiguration

/// Encapsulates all configurable carousel options.
struct CarouselConfiguration {
    var autoScrollInterval: TimeInterval?
    var isCircular: Bool
    var preloadOffset: Int
    var showsPageIndicator: Bool
    var pageIndicatorStyle: CarouselPageIndicatorStyle
    var contentMode: ContentMode
    var placeholder: UIImage?
    var errorImage: UIImage?

    static let `default` = CarouselConfiguration(
        autoScrollInterval: nil,
        isCircular: false,
        preloadOffset: 1,
        showsPageIndicator: true,
        pageIndicatorStyle: .default,
        contentMode: .fit,
        placeholder: nil,
        errorImage: nil
    )
}
