//
//  LoadingHUD.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 14/02/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import Foundation
import PKHUD
import UIKit

protocol HUDProviderType {
    func showHUD(_ loading: HeadUpDisplay.ContentType, delay: TimeInterval)
}

final class PKHUDProvider: HUDProviderType {

    func showHUD(_ loading: HeadUpDisplay.ContentType, delay: TimeInterval) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(loading.contentType, delay: delay)
    }
}

final class HeadUpDisplay {

    private let provider: HUDProviderType

    init(provider: HUDProviderType = PKHUDProvider()) {
        self.provider = provider
    }

    enum ContentType: Equatable {
        case success
        case error
        case progress
        case image(UIImage?)
        case rotatingImage(UIImage?)

        case labeledSuccess(title: String?, subtitle: String?)
        case labeledError(title: String?, subtitle: String?)
        case labeledProgress(title: String?, subtitle: String?)
        case labeledImage(image: UIImage?, title: String?, subtitle: String?)
        case labeledRotatingImage(image: UIImage?, title: String?, subtitle: String?)

        case label(String?)
        case systemActivity
        case customView(view: UIView)

        var contentType: HUDContentType {
            switch self {
            case .success:
                return .success
            case .error:
                return .error
            case .progress:
                return .progress
            case let .image(image):
                return .image(image)
            case let .rotatingImage(image):
                return .rotatingImage(image)
            case let .labeledSuccess(title: title, subtitle: subtitle):
                return .labeledSuccess(title: title, subtitle: subtitle)
            case let .labeledError(title: title, subtitle: subtitle):
                return .labeledError(title: title, subtitle: subtitle)
            case let .labeledProgress(title: title, subtitle: subtitle):
                return .labeledProgress(title: title, subtitle: subtitle)
            case let .labeledImage(image: image, title: title, subtitle: subtitle):
                return .labeledImage(image: image, title: title, subtitle: subtitle)
            case let .labeledRotatingImage(image: image, title: title, subtitle: subtitle):
                return .labeledRotatingImage(image: image, title: title, subtitle: subtitle)
            case let .label(text):
                return .label(text)
            case .systemActivity:
                return .systemActivity
            case let .customView(view: view):
                return .customView(view: view)
            }
        }

        static func == (lhs: ContentType, rhs: ContentType) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success),
                 (.error, .error),
                 (.progress, .progress),
                 (.systemActivity, .systemActivity):
                return true

            case let (.image(lhsImage), .image(rhsImage)),
                 let (.rotatingImage(lhsImage), .rotatingImage(rhsImage)):
                return lhsImage == rhsImage

            case let (.labeledSuccess(lhsTitle, lhsSubtitle), .labeledSuccess(rhsTitle, rhsSubtitle)):
                return lhsTitle == rhsTitle && lhsSubtitle == rhsSubtitle

            case let (.labeledError(lhsTitle, lhsSubtitle), .labeledError(rhsTitle, rhsSubtitle)):
                return lhsTitle == rhsTitle && lhsSubtitle == rhsSubtitle

            case let (.labeledProgress(lhsTitle, lhsSubtitle), .labeledProgress(rhsTitle, rhsSubtitle)):
                return lhsTitle == rhsTitle && lhsSubtitle == rhsSubtitle

            case let (.labeledImage(lhsImage, lhsTitle, lhsSubtitle), .labeledImage(rhsImage, rhsTitle, rhsSubtitle)):
                return lhsImage == rhsImage && lhsTitle == rhsTitle && lhsSubtitle == rhsSubtitle

            case let (.labeledRotatingImage(lhsImage, lhsTitle, lhsSubtitle), .labeledRotatingImage(rhsImage, rhsTitle, rhsSubtitle)):
                return lhsImage == rhsImage && lhsTitle == rhsTitle && lhsSubtitle == rhsSubtitle

            case let (.label(lhsText), .label(rhsText)):
                return lhsText == rhsText

            case let (.customView(lhsView), .customView(rhsView)):
                return lhsView == rhsView

            default:
                return false
            }
        }
    }

    func show(_ loading: ContentType, delay: TimeInterval = 0.2) {
        provider.showHUD(loading, delay: delay)
    }
}
