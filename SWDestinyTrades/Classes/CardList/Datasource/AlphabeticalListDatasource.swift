//
//  AlphabeticalListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class AlphabeticalListDatasource: NSObject, UITableViewDataSource, CardReturnable {
    private var tableView: UITableView?
    private var alphabeticallyCards: [String: [CardDTO]] = [:]
    private var sections: [String] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card, useIndex: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = alphabeticallyCards[sections[section]] else {
            return 0
        }
        return rows.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    // MARK: <CardReturnable>

    func getCard(at index: IndexPath) -> CardDTO? {
        return alphabeticallyCards[sections[index.section]]?[index.row]
    }

    func getCardList() -> [CardDTO] {
        var list = [CardDTO]()
        for cardList in alphabeticallyCards.values {
            list.append(contentsOf: Array(cardList))
        }
        return Sort.cardsAlphabetically(cardsArray: list)
    }

    // MARK: Sort options

    func sortAlphabetically(cardList: [CardDTO]) {
        sections = SectionsBuilder.alphabetically(cardList: cardList)
        alphabeticallyCards = Split.cardsAlphabetically(cardList: cardList, sections: sections)
        insertHeaderToDataSource()
        tableView?.reloadData()
    }

    private func insertHeaderToDataSource() {
        alphabeticallyCards[" "] = [CardDTO]()
        sections.insert(" ", at: 0)
    }
}
