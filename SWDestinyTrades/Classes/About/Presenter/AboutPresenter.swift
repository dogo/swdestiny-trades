//
//  AboutPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

protocol AboutPresenterProtocol {
    func didTouchHTTPUrl(_ url: URL)
}

final class AboutPresenter: AboutPresenterProtocol {

    private let navigator: AboutNavigator

    init(navigator: AboutNavigator) {
        self.navigator = navigator
    }

    func didTouchHTTPUrl(_ url: URL) {
        navigator.navigate(to: .webview(url: url))
    }
}
