//
//  DeckBuilderTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderTableView: UITableView, BaseDelegate {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    var tableViewDatasource: DeckBuilderDatasource?
    let deckBuilder = DeckBuilder()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        deckBuilder.delegate = self
        tableViewDatasource = DeckBuilderDatasource(tableView: self, delegate: deckBuilder)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(deck: DeckDTO) {
        tableViewDatasource?.updateTableViewData(deck: deck)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let currentDatasource = tableViewDatasource {
            if let card = currentDatasource.getCard(at: index) {
                didSelectCard?(currentDatasource.getCardList(), card)
            }
        }
    }
}
