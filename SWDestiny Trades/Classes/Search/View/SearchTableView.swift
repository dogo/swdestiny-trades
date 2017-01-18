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
    let search = Search()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        search.delegate = self
        searchDatasource = SearchDatasource(cards: [], tableView: self, delegate: search)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doingSearch(_ query: String) {
        searchDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        searchDatasource?.updateSearchList(cards)
    }

    // Mark: <SearchDelegate>

    internal func didSelectRow(at index: IndexPath) {
        if let card = searchDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
}
