//
//  AboutNavigator.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import SafariServices
import UIKit

final class AboutNavigator: Navigator {

    enum Destination {
        case webview(url: URL)
    }

    private weak var viewController: UIViewController?

    // MARK: - Initializer

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Navigator

    func navigate(to destination: Destination) {
        viewController?.present(makeViewController(for: destination), animated: true)
    }

    // MARK: - Private

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case let .webview(url):
            return SFSafariViewController(url: url)
        }
    }
}
