//
//  CardListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListTableView: UITableView, CardListViewDelegate, FilterHeaderViewDelegate {

    var didSelectCard: ((CardDTO) -> Void)?

    fileprivate var tableViewDatasource: CardListDatasource?
    fileprivate var tableViewDelegate: CardListDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDelegate = CardListDelegate(self, headerDelegate: self)
        tableViewDatasource = CardListDatasource(tableView: self, delegate: tableViewDelegate!)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCardList(_ cards: [CardDTO]) {
        tableViewDatasource?.originalCards = cards
        tableViewDatasource?.sortAlphabetically(cardList: cards)
    }

    // MARK: <CardListViewDelegate>

    internal func didSelectCard(at index: IndexPath) {
        if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
    
    // MARK: <FilterHeaderViewDelegate>
    
    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            tableViewDatasource?.sortAlphabetically()
        case 1:
            tableViewDatasource?.sortByColor()
        case 2:
            tableViewDatasource?.sortByCardNumber()
        default:
            break
        }
    }
}
