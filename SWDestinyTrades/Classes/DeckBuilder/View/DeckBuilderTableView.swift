//
//  DeckBuilderTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderTableView: UITableView, DeckBuilderViewType {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    weak var deckBuilderDelegate: DeckBuilderProtocol?

    private var tableViewDatasource: DeckBuilderDatasource?

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate = self
        tableViewDatasource?.collapsibleDelegate = self
        backgroundColor = .blackWhite
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(deck: DeckDTO) {
        tableViewDatasource = DeckBuilderDatasource(tableView: self, delegate: deckBuilderDelegate)
        tableViewDatasource?.updateTableViewData(deck: deck)
    }

    func getDeckList() -> [DeckBuilderDatasource.Section]? {
        return tableViewDatasource?.deckList
    }

    func didSelectRowAt(index: IndexPath) {
        if let currentDatasource = tableViewDatasource, let card = currentDatasource.getCard(at: index) {
            didSelectCard?(currentDatasource.getCardList(), card)
        }
    }
}

extension DeckBuilderTableView: CollapsibleTableViewHeaderDelegate {

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        tableViewDatasource?.toggleSection(header: header, section: section)
    }
}

extension DeckBuilderTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let currentDatasource = tableViewDatasource else {
            return 0
        }
        return currentDatasource.deckList[indexPath.section].collapsed ? 0 : BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: CollapsibleTableViewHeader?
        if header == nil {
            header = tableView.dequeueReusableHeaderFooterView(CollapsibleTableViewHeader.self)
        }

        header?.titleLabel.text = tableViewDatasource?.deckList[section].name
        header?.setCollapsed(tableViewDatasource?.deckList[section].collapsed ?? true)

        header?.section = section
        header?.delegate = self

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CollapsibleTableViewHeader.height()
    }
}
