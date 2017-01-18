//
//  DeckBuilderTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderTableView: UITableView, BaseDelegate {
    
    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAddItem: ((Void) -> Void)?
    
    fileprivate var tableViewDatasource: DeckBuilderDatasource?
    let deckBuilder = DeckBuilder()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        deckBuilder.delegate = self
        tableViewDatasource = DeckBuilderDatasource(tableView: self, delegate: deckBuilder)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewData(deckList: [CardDTO]) {
        tableViewDatasource?.updateTableViewData(list: deckList)
    }
    
    // Mark: <BaseDelegate>
    
    internal func didSelectRow(at index: IndexPath) {
        if index.row == tableViewDatasource?.deckList.count {
            didSelectAddItem?()
        } else if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
}
