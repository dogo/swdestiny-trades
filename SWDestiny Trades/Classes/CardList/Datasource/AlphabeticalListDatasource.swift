//
//  CardListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class AlphabeticalListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate var sections: [String] = []
    
    fileprivate var tableView: UITableView?
    
    // Alphabetical
    fileprivate var alphabeticallyCards: [String : [CardDTO]] = [ : ]

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
        return String(sections[section])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alphabeticallyCards[sections[section]]!.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return (alphabeticallyCards[sections[index.section]]?[index.row])
    }

    //Mark: Sort options

    public func sortAlphabetically(cardList: [CardDTO]) {
        alphabeticallyCards = Sort.splitDataAlphabetically(cardList: cardList).source
        sections = Sort.splitDataAlphabetically(cardList: cardList).firstLetters
        insertHeaderToDataSource()
        tableView?.reloadData()
    }
    
    fileprivate func insertHeaderToDataSource() {
        alphabeticallyCards[" "] = [CardDTO]()
        sections.insert(" ", at: 0)
    }
}
