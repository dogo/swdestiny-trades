//
//  HUDProviderSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class HUDProviderSpy: HUDProviderType {

    private(set) var didCallShowHUD = [(contentType: HeadUpDisplay.ContentType, delay: TimeInterval)]()
    func showHUD(_ contentType: HeadUpDisplay.ContentType, delay: TimeInterval) {
        didCallShowHUD.append((contentType, delay))
    }
}
