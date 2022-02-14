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

enum LoadingHUD {

    enum LoadingType {
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
    }

    static func show(_ loading: LoadingType, delay: TimeInterval = 0.2) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(loading.contentType, delay: delay)
    }
}
