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
        tableView.register(cellType: DeckBuilderCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckBuilderCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            if let rows = deckList[sections[indexPath.section]], rows.count == 0 {
                deckList.removeValue(forKey: sections[indexPath.section])
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .left)
            } else {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard deckList[sections[section]] != nil else {
            return nil
        }
        return sections[section].capitalized
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
        return (deckList[sections[index.section]]?[index.row])
    }

    public func getCardList() -> [CardDTO] {
        var list = [CardDTO]()
        for cardList in deckList.values {
            list.append(contentsOf: Array(cardList))
        }
        return list
    }

    public func updateTableViewData(deck: DeckDTO) {
        currentDeck = deck
        if !currentDeck.list.isEmpty {
            sections = SectionsBuilder.byType(cardList: Array(currentDeck.list))
            deckList = Split.cardsByType(cardList: Array(currentDeck.list), sections: sections)
        }
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        try! RealmManager.shared.realm.write {
            if let card = getCard(at: indexPath), let realmIndex = currentDeck.list.index(of: card) {
                currentDeck.list.remove(objectAtIndex: realmIndex)
                deckList[sections[indexPath.section]]?.remove(at: indexPath.row)
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
