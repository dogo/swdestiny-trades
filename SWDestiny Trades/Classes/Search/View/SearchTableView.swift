//
//  SearchTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SearchTableView: UITableView, SearchDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    fileprivate var searchDatasource: SearchDatasource?
    fileprivate var searchDelegate: SearchTableDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        searchDelegate = SearchTableDelegate(self)
        searchDatasource = SearchDatasource(cards: [], tableView: self, delegate: searchDelegate!)
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

    func doingSearch(_ query: String) {
        searchDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        searchDatasource?.updateSearchList(cards)
    }
    
    // Mark: <SearchDelegate>

    internal func didSelectCard(at index: IndexPath) {
        if let card = searchDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
}
