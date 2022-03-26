//
//  AddToDeckCardDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 25/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddToDeckCardDatasource: NSObject, UITableViewDataSource, UISearchBarDelegate {
    private var tableView: UITableView?
    private var searchIsActive = false
    private var cardsData: [CardDTO] = []
    private var filtered: [CardDTO] = []

    required init(cards: [CardDTO], tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        cardsData = cards
        filtered = cards
        self.tableView = tableView
        tableView.register(cellType: AddCardCell.self)
        tableView.register(headerFooterViewType: AddToDeckHeaderView.self)
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
        cardsData = cards
        filtered = cards
        tableView?.reloadData()
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

final class AddToDeckCardDelegate: NSObject, UITableViewDelegate {
    weak var delegate: SearchDelegate?
    private var header: AddToDeckHeaderView?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        delegate?.didSelectAccessory?(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if header == nil {
                header = tableView.dequeueReusableHeaderFooterView(AddToDeckHeaderView.self)
                header?.configureHeader()
                header?.delegate = delegate
            }
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height()
    }
}
