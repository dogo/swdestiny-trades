//
//  SearchBar.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SearchBar: UISearchBar {

    var doingSearch: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        searchBarStyle = .minimal
        placeholder = L10n.allCards
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBar: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doingSearch?(searchBar.nonOptionalText)
    }
}
