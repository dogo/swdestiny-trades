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

    fileprivate var initialEdgeInsets: UIEdgeInsets = .zero
    fileprivate var searchDatasource: SearchDatasource?
    let search = Search()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        search.delegate = self
        searchDatasource = SearchDatasource(cards: [], tableView: self, delegate: search)
        self.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func doingSearch(_ query: String) {
        searchDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        searchDatasource?.updateSearchList(cards)
    }

    // MARK: <SearchDelegate>

    internal func didSelectRow(at index: IndexPath) {
        if let card = searchDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }

    // MARK: Keyboard handling

    @objc
    private func keyboardDidShow(notification: Notification) {

        initialEdgeInsets = self.contentInset

        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardFrame = self.convert(keyboardSize, to: nil)
                UIView.animate(withDuration: 0.3) {
                    let tabBarHeight: CGFloat = 49.0
                    let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height - tabBarHeight, right: 0)
                    self.contentInset = edgeInset
                    self.scrollIndicatorInsets = edgeInset
                }
            }
        }
    }

    @objc
    private func keyboardDidHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentInset = self.initialEdgeInsets
            self.scrollIndicatorInsets = self.initialEdgeInsets
        }
    }
}
