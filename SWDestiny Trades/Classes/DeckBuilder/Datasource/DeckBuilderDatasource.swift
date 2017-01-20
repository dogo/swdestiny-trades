//
//  DeckBuilderDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class DeckBuilderDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    var deckList: [CardDTO] = []

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: CardCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        if indexPath.row == deckList.count {
            cell.accessoryType = .none
            cell.textLabel?.text = NSLocalizedString("ADD_CARD", comment: "")
            cell.textLabel?.textColor = UIColor.darkGray
        } else {
            cell.textLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
            if let card = getCard(at: indexPath) {
                cell.configureCell(card: card, useIndex: false)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == deckList.count {
            return false
        }
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckList.count + 1
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return deckList[index.row]
    }

    public func updateTableViewData(list: [CardDTO]) {
        deckList = list
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        try! RealmManager.shared.realm.write {
            if let card = getCard(at: indexPath) {
                RealmManager.shared.realm.delete(card)
                deckList.remove(at: indexPath.row)
            }
        }
    }
}

class DeckBuilder: NSObject, UITableViewDelegate {

    weak var delegate: BaseDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
