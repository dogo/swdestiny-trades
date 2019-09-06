//
//  DeckListDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListDatasource: NSObject, UITableViewDataSource {

    private var tableView: UITableView?
    private var deckList: [DeckDTO] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: DeckListCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckListCell.self)
        cell.configureCell(deck: getDeck(at: indexPath))
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
        do {
            try RealmManager.shared.realm.write { [weak self] in
                guard let self = self else { return }
                RealmManager.shared.realm.delete(self.deckList[indexPath.row])
                self.deckList.remove(at: indexPath.row)
            }
        } catch let error as NSError {
            debugPrint("Error opening realm: \(error)")
        }
    }

    public func getDeck(at index: IndexPath) -> DeckDTO {
        return deckList[index.row]
    }

    public func updateTableViewData(list: [DeckDTO]) {
        deckList = list
        tableView?.reloadData()
    }

    public func insert(deck: DeckDTO) {
        do {
            try RealmManager.shared.realm.write { [weak self] in
                RealmManager.shared.realm.add(deck)
                self?.deckList.append(deck)
                self?.tableView?.reloadData()
            }
        } catch let error as NSError {
            debugPrint("Error opening realm: \(error)")
        }
    }
}
