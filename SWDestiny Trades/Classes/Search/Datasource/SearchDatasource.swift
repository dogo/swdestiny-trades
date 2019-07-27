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
    private var searchIsActive: Bool = false
    private var cardsData: [CardDTO] = []
    private var filtered: [CardDTO] = []

    required init(cards: [CardDTO], tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.cardsData = cards
        self.filtered = cards
        self.tableView = tableView
        tableView.register(cellType: CardSearchCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardSearchCell.self)
        cell.configureCell(cardDTO: getCard(at: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsActive ? filtered.count : cardsData.count
    }

    func updateSearchList(_ cards: [CardDTO]) {
        self.cardsData = cards
        self.filtered = cards
        self.tableView?.reloadData()
    }

    func getCard(at index: IndexPath) -> CardDTO {
        return searchIsActive ? filtered[index.row] : cardsData[index.row]
    }

    func doingSearch(_ searchText: String) {

        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR code CONTAINS[cd] %@", searchText, searchText)
        filtered = cardsData.filter {
            predicate.evaluate(with: $0)
        }

        searchIsActive = !searchText.trim().isEmpty
        tableView?.reloadData()
    }
}

class Search: NSObject, UITableViewDelegate {

    weak var delegate: SearchDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
