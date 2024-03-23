//
//  UserCollectionViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class UserCollectionViewSpy: UITableView, UserCollectionViewType {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?
    var userCollectionDelegate: (any UserCollectionProtocol)?

    private(set) var didCallUpdateTableViewData = [UserCollectionDTO]()
    func updateTableViewData(collection: UserCollectionDTO) {
        didCallUpdateTableViewData.append(collection)
    }

    private(set) var didCallSort = [Int]()
    func sort(_ selectedIndex: Int) {
        didCallSort.append(selectedIndex)
    }

    private(set) var didCallGetCardListCount = 0
    var cardList: [CardDTO]? = [.stub()]
    func getCardList() -> [CardDTO]? {
        didCallGetCardListCount += 1
        return cardList
    }
}
