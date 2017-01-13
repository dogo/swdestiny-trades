//
//  AddCardTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardTableView: UITableView, SearchDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    fileprivate var tableDatasource: AddCardDatasource?
    fileprivate var tableDelegate: AddCardTableDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableDelegate = AddCardTableDelegate(self)
        tableDatasource = AddCardDatasource(cards: [], tableView: self, delegate: tableDelegate!)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doingSearch(_ query: String) {
        tableDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        tableDatasource?.updateSearchList(cards)
    }

    // Mark: <SearchDelegate>

    internal func didSelectCard(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }

    internal func didSelectAccessory(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectAccessory?(card)
        }
    }
}
