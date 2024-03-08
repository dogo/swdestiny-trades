//
//  SearchDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SearchDatasource: NSObject, UITableViewDataSource, UISearchBarDelegate {

    private var tableView: UITableView?
    private var cardsData: [CardDTO] = []

    required init(cards: [CardDTO], tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        cardsData = cards
        self.tableView = tableView
        tableView.register(cellType: CardSearchCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardSearchCell.self)
        cell.configureCell(cardDTO: cardsData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsData.count
    }

    func updateSearchList(_ cards: [CardDTO]) {
        cardsData = cards
        tableView?.reloadData()
    }

    func getCard(at index: IndexPath) -> CardDTO {
        return cardsData[index.row]
    }
}

final class Search: NSObject, UITableViewDelegate {
    weak var delegate: SearchDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
