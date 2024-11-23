//
//  UserCollectionPresenter+Mirror.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 16/11/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension UserCollectionPresenter {

    var currentSortIndex: UserCollectionPresenter.SortType? {
        Mirror.extract(variable: "currentSortIndex", from: self)
    }
}
