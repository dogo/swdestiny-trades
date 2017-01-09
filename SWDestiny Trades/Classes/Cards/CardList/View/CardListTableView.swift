//
//  CardListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListTableView: UITableView, CardListViewDelegate {
    
    var didSelectCard: ((CardDTO) -> Void)?
    
    fileprivate var cardListDatasource: CardListDatasource?
    fileprivate var cardListDelegate: CardListDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        cardListDelegate = CardListDelegate(self)
        cardListDatasource = CardListDatasource(tableView: self, delegate: cardListDelegate!)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let path = indexPathForSelectedRow {
            deselectRow(at: path, animated: true)
        }
    }
    
    func updateCardList(_ cards: [CardDTO]) {
        cardListDatasource?.sortAndSplitTableData(cardList: cards)
    }
    
    // MARK: <CardListViewDelegate>
    
    internal func didSelectCard(at index: IndexPath) {
        if let card = cardListDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
}
