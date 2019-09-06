//
//  DeckBuilderDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderDatasource: NSObject, UITableViewDataSource {

    struct Section {
        var name: String
        var items: [CardDTO]
        var collapsed: Bool

        init(name: String, items: [CardDTO], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }

    private var tableView: UITableView?
    private var currentDeck: DeckDTO?
    var deckList = [Section]()

    weak var collapsibleDelegate: CollapsibleTableViewHeaderDelegate?

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: DeckBuilderCell.self)
        tableView.register(headerFooterViewType: CollapsibleTableViewHeader.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckBuilderCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card)
            cell.stepperValueChanged = { [weak self] value, cell in
                self?.updateCardQuantity(newValue: value, cell: cell)
            }
            cell.eliteButtonTouched = { [weak self] isElite, cell in
                self?.updateCharacterElite(newValue: isElite, cell: cell)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            if deckList[indexPath.section].items.isEmpty {
                deckList.remove(at: indexPath.section)
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return deckList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckList[section].collapsed ? 0 : deckList[section].items.count
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return deckList[index.section].items[index.row]
    }

    public func getCardList() -> [CardDTO] {
        var list = [CardDTO]()
        for cardList in deckList {
            for card in cardList.items {
                list.append(card)
            }
        }
        return list
    }

    public func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !deckList[section].collapsed

        // Toggle collapse
        deckList[section].collapsed = collapsed
        header.setCollapsed(collapsed)

        // Adjust the height of the rows inside the section
        tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    public func updateTableViewData(deck: DeckDTO?) {
        if let currentDeck = deck {
            self.currentDeck = deck
            if !currentDeck.list.isEmpty {
                let local = Split.cardsByType(cardList: Array(currentDeck.list), sections: SectionsBuilder.byType(cardList: Array(currentDeck.list)))
                deckList.removeAll()
                for card in local {
                    deckList.append(Section(name: card.key, items: card.value))
                }
            }
        }
        tableView?.reloadData()
    }

    private func updateCardQuantity(newValue: Int, cell: DeckBuilderCell) {
        guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
        if let card = self.getCard(at: indexPath) {
            do {
                try RealmManager.shared.realm.write {
                    card.quantity = newValue
                }
            } catch let error as NSError {
                debugPrint("Error opening realm: \(error)")
            }
        }
    }

    private func updateCharacterElite(newValue: Bool, cell: DeckBuilderCell) {
        guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
        if let card = self.getCard(at: indexPath) {
            do {
                try RealmManager.shared.realm.write {
                    card.isElite = newValue
                }
            } catch let error as NSError {
                debugPrint("Error opening realm: \(error)")
            }
        }
    }

    private func remove(at indexPath: IndexPath) {
        do {
            try RealmManager.shared.realm.write { [weak self] in
                if let card = self?.getCard(at: indexPath), let realmIndex = self?.currentDeck?.list.index(of: card) {
                    self?.currentDeck?.list.remove(at: realmIndex)
                    self?.deckList[indexPath.section].items.remove(at: indexPath.row)
                }
            }
        } catch let error as NSError {
            debugPrint("Error opening realm: \(error)")
        }
    }
}
