//
//  SearchBar.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar, UISearchBarDelegate {

    var doingSearch: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.searchBarStyle = .minimal
        self.placeholder = L10n.allCards
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doingSearch?(searchText)
    }
}
