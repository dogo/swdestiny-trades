//
//  NumberListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class NumberListDatasource: NSObject, UITableViewDataSource, CardReturnable {
    private var tableView: UITableView?
    private var numberCards: [CardDTO] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card, useIndex: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberCards.count
    }

    // MARK: <CardReturnable>

    func getCard(at index: IndexPath) -> CardDTO? {
        return numberCards[index.row]
    }

    func getCardList() -> [CardDTO] {
        return numberCards
    }

    // MARK: Sort options

    func sortByCardNumber(cardList: [CardDTO]) {
        numberCards = cardList.sorted {
            $0.code < $1.code
        }
        tableView?.reloadData()
    }
}
