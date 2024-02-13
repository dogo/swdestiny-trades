//
//  DeckGraphViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckGraphViewType where Self: UIView {

    func updateCollecionViewData(deck: DeckDTO)
}
