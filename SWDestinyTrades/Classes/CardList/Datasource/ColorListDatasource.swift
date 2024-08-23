//
//  ColorListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class ColorListDatasource: NSObject, UITableViewDataSource, CardReturnable {
    private weak var tableView: UITableView?
    private var colorCards: [String: [CardDTO]] = [:]
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
        return sections[section].capitalized
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorCards[sections[section]]?.count ?? 0
    }

    // MARK: - CardReturnable

    func getCard(at indexPath: IndexPath) -> CardDTO? {
        return colorCards[sections[indexPath.section]]?[indexPath.row]
    }

    func getCardList() -> [CardDTO] {
        return colorCards.values.flatMap { $0 }
    }

    // MARK: - Sorting

    func sortByColor(cardList: [CardDTO]) {
        sections = SectionsBuilder.byColor(cardList: cardList)
        colorCards = Split.cardsByColor(cardList: cardList, sections: sections)
        insertHeaderToDataSource()
        tableView?.reloadData()
    }

    private func insertHeaderToDataSource() {
        colorCards[" "] = []
        sections.insert(" ", at: 0)
    }
}
