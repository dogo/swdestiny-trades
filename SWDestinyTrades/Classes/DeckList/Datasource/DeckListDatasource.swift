//
//  DeckListDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol DeckListProtocol: AnyObject {
    func remove(deck: DeckDTO)
    func insert(deck: DeckDTO)
    func rename(name: String, deck: DeckDTO)
}

final class DeckListDatasource: NSObject, UITableViewDataSource {
    private var tableView: UITableView?
    private var deckList: [DeckDTO] = []
    private weak var delegate: DeckListProtocol?

    required init(tableView: UITableView, delegate: DeckListProtocol) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        tableView.register(cellType: DeckListCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckListCell.self)
        cell.configureCell(deck: getDeck(at: indexPath))
        cell.accessoryButtonTouched = { [weak self] name, deck in
            self?.delegate?.rename(name: name, deck: deck)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckList.count
    }

    private func remove(at indexPath: IndexPath) {
        delegate?.remove(deck: deckList[indexPath.row])
        deckList.remove(at: indexPath.row)
    }

    func getDeck(at index: IndexPath) -> DeckDTO {
        return deckList[index.row]
    }

    func updateTableViewData(list: [DeckDTO]) {
        deckList = list
        tableView?.reloadData()
    }

    func insert(deck: DeckDTO) {
        delegate?.insert(deck: deck)
        deckList.append(deck)
        tableView?.reloadData()
    }
}
