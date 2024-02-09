//
//  DeckBuilderViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 09/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckBuilderViewType where Self: UIView {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)? { get set }

    func updateTableViewData(deck: DeckDTO)
    func getDeckList() -> [DeckBuilderDatasource.Section]?
}
