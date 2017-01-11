//
//  NumberListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class NumberListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate var tableView: UITableView?
    fileprivate var numberCards: [CardDTO] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: CardCell.self)
        tableView.register(headerFooterViewType: FilterHeaderView.self)
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.sectionIndexBackgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card, useIndex: true)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberCards.count
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return numberCards[index.row]
    }

    //Mark: Sort options  
    
    public func sortByCardNumber(cardList: [CardDTO]) {
        numberCards = cardList.sorted {
            $0.code < $1.code
        }
        tableView?.reloadData()
    }
}
