//
//  AddCardDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol AddCardDatasourceProtocol: UITableViewDataSource {

    func updateSearchList(_ cards: [CardDTO])
    func getCard(at index: IndexPath) -> CardDTO
    func doingSearch(_ searchText: String)
}

final class AddCardDatasource: NSObject, UITableViewDataSource, UISearchBarDelegate {
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
}

extension AddCardDatasource: AddCardDatasourceProtocol {

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

final class AddCardTableDelegate: NSObject, UITableViewDelegate {
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
