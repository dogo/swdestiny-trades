//
//  UserCollectionViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol UserCollectionViewType where Self: UITableView {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)? { get set }

    func updateTableViewData(collection: UserCollectionDTO)
    func sort(_ selectedIndex: Int)
    func getCardList() -> [CardDTO]?
}
