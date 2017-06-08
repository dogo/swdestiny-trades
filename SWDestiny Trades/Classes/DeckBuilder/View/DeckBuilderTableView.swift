//
//  DeckBuilderTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderTableView: UITableView, BaseDelegate, CollapsibleTableViewHeaderDelegate {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    var tableViewDatasource: DeckBuilderDatasource?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDatasource = DeckBuilderDatasource(tableView: self)
        tableViewDatasource?.delegate = self
        tableViewDatasource?.collapsibleDelegate = self
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

    // MARK: <CollapsibleTableViewHeaderDelegate>

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        tableViewDatasource?.toggleSection(header: header, section: section)
    }
}
