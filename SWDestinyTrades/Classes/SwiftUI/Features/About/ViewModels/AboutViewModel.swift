//
//  AboutViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 14/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@Observable
@MainActor
final class AboutViewModel {

    func openWebsite(using coordinator: any NavigationCoordinatorProtocol) {
        if let url = URL(string: L10n.swdestinydbWebsite) {
            coordinator.navigate(to: .webview(url: url))
        }
    }
}
