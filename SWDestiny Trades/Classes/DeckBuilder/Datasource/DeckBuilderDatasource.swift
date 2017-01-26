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
    fileprivate var deckList: [String : [CardDTO]] = [ : ]
    fileprivate var sections: [String] = []
    fileprivate var currentDeck: DeckDTO!

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
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card, useIndex: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard deckList[sections[section]] != nil else {
            return nil
        }
        return sections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = deckList[sections[section]] else {
            return 0
        }
        return rows.count
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return (deckList[sections[index.section]]?[index.row])!
    }

    public func updateTableViewData(deck: DeckDTO) {
        currentDeck = deck
        if !currentDeck.list.isEmpty {
            deckList = Sort.splitCardsByType(cardList: Array(currentDeck.list)).source
            sections = Sort.splitCardsByType(cardList: Array(currentDeck.list)).sections
        }
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        try! RealmManager.shared.realm.write {
            currentDeck.list.remove(objectAtIndex: indexPath.row)
            deckList[sections[indexPath.section]]?.remove(at: indexPath.row)
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
