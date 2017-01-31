//
//  CardListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class AlphabeticalListDatasource: NSObject, UITableViewDataSource, CardReturnable {

    fileprivate var tableView: UITableView?
    fileprivate var alphabeticallyCards: [String : [CardDTO]] = [ : ]
    fileprivate var sections: [String] = []

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

    //Mark: <CardReturnable>

    internal func getCard(at index: IndexPath) -> CardDTO? {
        return (alphabeticallyCards[sections[index.section]]?[index.row])
    }

    //Mark: Sort options

    public func sortAlphabetically(cardList: [CardDTO]) {
        alphabeticallyCards = Sort.splitCardsAlphabetically(cardList: cardList).source
        sections = Sort.splitCardsAlphabetically(cardList: cardList).firstLetters
        insertHeaderToDataSource()
        tableView?.reloadData()
    }

    fileprivate func insertHeaderToDataSource() {
        alphabeticallyCards[" "] = [CardDTO]()
        sections.insert(" ", at: 0)
    }
}
