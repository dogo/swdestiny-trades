//
//  CardListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class CardListDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    fileprivate var swdCards: [String : [CardDTO]] = [ : ]
    fileprivate var sectionLetters: [String] = []
    
    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        //self.cardsData = cards
        self.tableView = tableView
        tableView.register(cellType: CardCell.self)
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        cell.configureCell(cardDTO: getCard(at: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionLetters[section])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLetters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swdCards[sectionLetters[section]]!.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionLetters
    }

    public func getCard(at index: IndexPath) -> CardDTO {
        return (swdCards[sectionLetters[index.section]]?[index.row])!
    }

    // MARK: - Split and Sort UITableView source

    func createTableData(cardList: [CardDTO]) -> (firstLetters: [String], source: [String : [CardDTO]]) {

        // Build Character Set
        var letters = Set<String>()

        func getFirstLetter(cardDTO: CardDTO) -> String {
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        cardList.forEach {_ = letters.insert(getFirstLetter(cardDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [String: [CardDTO]]()

        for symbol in letters {

            var cardsDTO = [CardDTO]()

            for card in cardList {
                if symbol == getFirstLetter(cardDTO: card) {
                    cardsDTO.append(card)
                }
            }
            tableViewSource[symbol] = cardsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    public func sortAndSplitTableData(cardList: [CardDTO]) {
        swdCards = createTableData(cardList: cardList).source
        sectionLetters = createTableData(cardList: cardList).firstLetters
        tableView?.reloadData()
    }
}

class CardListDelegate: NSObject, UITableViewDelegate {

    private let delegate: CardListViewDelegate

    init(_ delegate: CardListViewDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectCard(at: indexPath)
    }
}
