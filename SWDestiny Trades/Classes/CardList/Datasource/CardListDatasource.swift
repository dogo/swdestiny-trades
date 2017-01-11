//
//  CardListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class CardListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate enum PresentationState {
        case color, number, alphabet
    }
    
    fileprivate var currentPresentationState = PresentationState.alphabet

    var originalCards: [CardDTO] = []
    
    fileprivate var tableView: UITableView?
    
    // Alphabetical
    fileprivate var alphabeticallyCards: [String : [CardDTO]] = [ : ]
    fileprivate var sectionLetters: [String] = []
    
    // Color
    fileprivate var colorCards: [CardDTO] = []
    
    // Number
    fileprivate var numberCards: [CardDTO] = []

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: CardCell.self)
        tableView.register(headerFooterViewType: FilterHeaderView.self)
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.sectionIndexBackgroundColor = .clear
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
        switch self.currentPresentationState {
        case .alphabet:
            return String(sectionLetters[section])
        default:
            return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentPresentationState {
        case .alphabet:
            return sectionLetters.count
        default:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentPresentationState {
        case .alphabet:
            return alphabeticallyCards[sectionLetters[section]]!.count
        case .color:
            return colorCards.count
        case .number:
            return numberCards.count
        }
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        switch self.currentPresentationState {
        case .alphabet:
            return sectionLetters
        default:
            return nil
        }
    }

    public func getCard(at index: IndexPath) -> CardDTO {
        switch self.currentPresentationState {
        case .alphabet:
            return (alphabeticallyCards[sectionLetters[index.section]]?[index.row])!
        case .color:
            return colorCards[index.row]
        case .number:
            return numberCards[index.row]
        }
    }

    // MARK: - Sort UITableView source

    func sortAndSplitTableData(cardList: [CardDTO]) -> (firstLetters: [String], source: [String : [CardDTO]]) {

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

    public func sortAlphabetically(cardList: [CardDTO]) {
        currentPresentationState = .alphabet
        alphabeticallyCards = sortAndSplitTableData(cardList: cardList).source
        sectionLetters = sortAndSplitTableData(cardList: cardList).firstLetters
        insertHackToDataSource()
        tableView?.reloadData()
    }
    
    fileprivate func insertHackToDataSource() {
        alphabeticallyCards[" "] = [CardDTO]()
        sectionLetters.insert(" ", at: 0)
    }
    
    public func sortAlphabetically() {
        sortAlphabetically(cardList: originalCards)
    }
    
    public func sortByColor() {
        currentPresentationState = .color
        colorCards = originalCards.sorted {
            $0.factionCode < $1.factionCode
        }
        tableView?.reloadData()
    }
    
    public func sortByCardNumber() {
        currentPresentationState = .number
        numberCards = originalCards.sorted {
            $0.code < $1.code
        }
        tableView?.reloadData()
    }
}

class CardListDelegate: NSObject, UITableViewDelegate {

    private let cardListViewDelegate: CardListViewDelegate
    private let filterHeaderViewDelegate: FilterHeaderViewDelegate

    init(_ cardListDelegate: CardListViewDelegate, headerDelegate: FilterHeaderViewDelegate) {
        self.cardListViewDelegate = cardListDelegate
        self.filterHeaderViewDelegate = headerDelegate
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardListViewDelegate.didSelectCard(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(FilterHeaderView.self)
            header?.configureHeader()
            header?.delegate = filterHeaderViewDelegate
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height()
    }
}
