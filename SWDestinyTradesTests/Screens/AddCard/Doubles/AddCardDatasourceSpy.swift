//
//  AddCardDatasourceSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class AddCardDatasourceSpy: NSObject, AddCardDatasourceProtocol {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    private(set) var didCallUpdateSearchList = [CardDTO]()
    func updateSearchList(_ cards: [CardDTO]) {
        didCallUpdateSearchList.append(contentsOf: cards)
    }

    private(set) var didCallGetCard = [IndexPath]()
    func getCard(at index: IndexPath) -> CardDTO {
        didCallGetCard.append(index)
        return .stub()
    }

    private(set) var didCallDoingSearch = [String]()
    func doingSearch(_ query: String) {
        didCallDoingSearch.append(query)
    }
}
