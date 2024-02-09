//
//  DeckBuilderDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol DeckBuilderProtocol: AnyObject {
    func updateCardQuantity(newValue: Int, card: CardDTO)
    func updateCharacterElite(newValue: Bool, card: CardDTO)
    func remove(at index: Int)
}

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
    private weak var delegate: DeckBuilderProtocol?
    var deckList = [Section]()

    weak var collapsibleDelegate: CollapsibleTableViewHeaderDelegate?

    required init(tableView: UITableView, delegate: DeckBuilderProtocol?) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        tableView.register(cellType: DeckBuilderCell.self)
        tableView.register(headerFooterViewType: CollapsibleTableViewHeader.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckBuilderCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card)
            cell.stepperValueChanged = { [weak self] value in
                self?.delegate?.updateCardQuantity(newValue: value, card: card)
            }
            cell.eliteButtonTouched = { [weak self] isElite in
                self?.delegate?.updateCharacterElite(newValue: isElite, card: card)
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

    func getCard(at index: IndexPath) -> CardDTO? {
        return deckList[index.section].items[index.row]
    }

    func getCardList() -> [CardDTO] {
        var list = [CardDTO]()
        for cardList in deckList {
            for card in cardList.items {
                list.append(card)
            }
        }
        return list
    }

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !deckList[section].collapsed

        // Toggle collapse
        deckList[section].collapsed = collapsed
        header.setCollapsed(collapsed)

        // Adjust the height of the rows inside the section
        tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func updateTableViewData(deck: DeckDTO?) {
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

    private func remove(at indexPath: IndexPath) {
        if let card = getCard(at: indexPath), let index = currentDeck?.list.index(of: card) {
            deckList[indexPath.section].items.remove(at: indexPath.row)
            delegate?.remove(at: index)
        }
    }
}
