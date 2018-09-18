//
//  ToastMessages.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 02/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import SwiftMessages

final class ToastMessages {

    static func showNetworkErrorMessage() {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.defaultConfig
        config.duration = .forever

        errorView.configureTheme(.error)
        errorView.button?.setTitle(L10n.close, for: .normal)
        errorView.buttonTapHandler = { _ in
            SwiftMessages.hide()
        }
        errorView.tapHandler = { _ in
            let url = URL(string: "http://www.swdestinydb.com")! // swiftlint:disable:this force_unwrapping
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        errorView.configureContent(title: "", body: L10n.errorMessage)
        SwiftMessages.show(config: config, view: errorView)
    }

    static func showInfoMessage(title: String, message: String) {
        let infoView = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 2.0)

        infoView.button?.isHidden = true
        infoView.configureTheme(.info)
        infoView.tapHandler = { _ in
            SwiftMessages.hide()
        }

        infoView.configureContent(title: title, body: message)
        SwiftMessages.show(config: config, view: infoView)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
