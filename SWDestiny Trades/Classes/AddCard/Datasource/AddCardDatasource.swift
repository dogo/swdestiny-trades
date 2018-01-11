//
//  AddCardDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardDatasource: NSObject, UITableViewDataSource, UISearchBarDelegate {

    fileprivate var tableView: UITableView?
    fileprivate var searchIsActive = false
    fileprivate var cardsData: [CardDTO] = []
    fileprivate var filtered: [CardDTO] = []

    required init(cards: [CardDTO], tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.cardsData = cards
        self.filtered = cards
        self.tableView = tableView
        tableView.register(cellType: AddCardCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddCardCell.self)
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
        filtered = cardsData.filter { $0.name.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil }
        searchIsActive = !searchText.trim().isEmpty
        tableView?.reloadData()
    }
}

class AddCardTableDelegate: NSObject, UITableViewDelegate {

    weak var delegate: SearchDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        delegate?.didSelectAccessory?(at: indexPath)
    }
}
