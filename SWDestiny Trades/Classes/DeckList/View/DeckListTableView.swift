//
//  DeckListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListTableView: UITableView, SearchDelegate {
    
    var didSelectDeck: ((DeckDTO) -> Void)?
    
    fileprivate var tableViewDatasource: DeckListDatasource?
    let deckList = DeckList()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        deckList.delegate = self
        tableViewDatasource = DeckListDatasource(tableView: self, delegate: deckList)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewData(decksList: [DeckDTO]) {
        tableViewDatasource?.updateTableViewData(list: decksList)
    }
    
    func insert(deck: DeckDTO) {
        tableViewDatasource?.insert(deck: deck)
    }
    
    // Mark: <BaseDelegate>
    
    internal func didSelectRow(at index: IndexPath) {
        if let deck = tableViewDatasource?.getDeck(at: index) {
            didSelectDeck?(deck)
        }
    }
}
