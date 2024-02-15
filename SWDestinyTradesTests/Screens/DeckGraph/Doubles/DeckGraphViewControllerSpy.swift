//
//  DeckGraphViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckGraphViewControllerSpy: UIViewController, DeckGraphViewControllerProtocol {

    private(set) var didCallUpdateCollecionViewData = [DeckDTO]()
    func updateCollecionViewData(deck: DeckDTO) {
        didCallUpdateCollecionViewData.append(deck)
    }

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }
}
