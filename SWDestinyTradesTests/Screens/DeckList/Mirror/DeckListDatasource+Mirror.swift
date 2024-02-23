//
//  DeckListDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension DeckListDatasource {

    var deckList: [DeckDTO] {
        Mirror.extract(variable: "deckList", from: self)!
    }
}
