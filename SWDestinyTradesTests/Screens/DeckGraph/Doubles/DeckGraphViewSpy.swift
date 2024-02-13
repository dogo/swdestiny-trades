//
//  DeckGraphViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class DeckGraphViewSpy: UIView, DeckGraphViewType {

    private(set) var didCallUpdateCollecionViewData = [DeckDTO]()
    func updateCollecionViewData(deck: DeckDTO) {
        didCallUpdateCollecionViewData.append(deck)
    }
}
