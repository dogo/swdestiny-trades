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

    private var searchDatasource: SearchDatasource?
    private let search = Search()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        search.delegate = self
        searchDatasource = SearchDatasource(cards: [], tableView: self, delegate: search)
        backgroundColor = .blackWhite
        keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSearchList(_ cards: [CardDTO]) {
        searchDatasource?.updateSearchList(cards)
    }

    // MARK: <SearchDelegate>

    func didSelectRow(at index: IndexPath) {
        if let card = searchDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }

    // MARK: Keyboard handling

    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo: NSDictionary = notification.userInfo as NSDictionary? {
            if let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = keyboardInfo.cgRectValue.size
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                contentInset = contentInsets
                scrollIndicatorInsets = contentInsets
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        contentInset = .zero
        scrollIndicatorInsets = .zero
    }
}
