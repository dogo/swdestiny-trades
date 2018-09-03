//
//  DeckBuilderTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderTableView: UITableView, CollapsibleTableViewHeaderDelegate {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    var tableViewDatasource: DeckBuilderDatasource?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDatasource = DeckBuilderDatasource(tableView: self)
        self.delegate = self
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

// MARK: <UITableViewDelegate>

extension DeckBuilderTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewDatasource!.deckList[indexPath.section].collapsed ? 0 : BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: CollapsibleTableViewHeader?
        if header == nil {
            header = tableView.dequeueReusableHeaderFooterView(CollapsibleTableViewHeader.self)
        }

        header?.titleLabel.text = self.tableViewDatasource!.deckList[section].name
        header?.setCollapsed(self.tableViewDatasource!.deckList[section].collapsed)

        header?.section = section
        header?.delegate = self

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CollapsibleTableViewHeader.height()
    }
}
