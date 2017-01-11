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
    fileprivate var sections: [String] = []
    
    fileprivate var tableView: UITableView?
    
    // Alphabetical
    fileprivate var alphabeticallyCards: [String : [CardDTO]] = [ : ]
    
    // Color
    fileprivate var colorCards: [String : [CardDTO]] = [ : ]
    
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
        cell.configureCell(card: getCard(at: indexPath), useIndex: currentPresentationState == .number)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.currentPresentationState {
        case .alphabet,
             .color:
            return String(sections[section])
        default:
            return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentPresentationState {
        case .alphabet,
             .color:
            return sections.count
        default:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentPresentationState {
        case .alphabet:
            return alphabeticallyCards[sections[section]]!.count
        case .color:
            return colorCards[sections[section]]!.count
        case .number:
            return numberCards.count
        }
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        switch self.currentPresentationState {
        case .alphabet,
             .color:
            return sections
        default:
            return nil
        }
    }

    public func getCard(at index: IndexPath) -> CardDTO {
        switch self.currentPresentationState {
        case .alphabet:
            return (alphabeticallyCards[sections[index.section]]?[index.row])!
        case .color:
            return (colorCards[sections[index.section]]?[index.row])!
        case .number:
            return numberCards[index.row]
        }
    }

    //Mark: Sort options

    public func sortAlphabetically(cardList: [CardDTO]) {
        currentPresentationState = .alphabet
        alphabeticallyCards = Sort.splitDataAlphabetically(cardList: cardList).source
        sections = Sort.splitDataAlphabetically(cardList: cardList).firstLetters
        insertHeaderToDataSource()
        tableView?.reloadData()
    }
    
    fileprivate func insertHeaderToDataSource() {
        alphabeticallyCards[" "] = [CardDTO]()
        colorCards[" "] = [CardDTO]()
        sections.insert(" ", at: 0)
    }
    
    public func sortAlphabetically() {
        sortAlphabetically(cardList: originalCards)
    }
    
    public func sortByColor() {
        currentPresentationState = .color
        colorCards = Sort.splitDataByColor(cardList: originalCards).source
        sections = Sort.splitDataByColor(cardList: originalCards).sections
        insertHeaderToDataSource()
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
    private var header: FilterHeaderView?

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
            if header == nil {
                header = tableView.dequeueReusableHeaderFooterView(FilterHeaderView.self)
                header?.configureHeader()
                header?.delegate = filterHeaderViewDelegate
            }
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height()
    }
}
