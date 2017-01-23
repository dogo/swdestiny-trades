//
//  DeckListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListTableView: UITableView, BaseDelegate {

    var didSelectDeck: ((DeckDTO) -> Void)?

    fileprivate var initialEdgeInsets: UIEdgeInsets = .zero
    fileprivate var tableViewDatasource: DeckListDatasource?
    let deckList = DeckList()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        deckList.delegate = self
        tableViewDatasource = DeckListDatasource(tableView: self, delegate: deckList)
        self.backgroundColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func updateTableViewData(decksList: [DeckDTO]) {
        tableViewDatasource?.updateTableViewData(list: decksList)
    }

    func insert(deck: DeckDTO) {
        tableViewDatasource?.insert(deck: deck)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRow(at index: IndexPath) {
        if let deck = tableViewDatasource?.getDeck(at: index) {
            didSelectDeck?(deck)
        }
    }

    // MARK: Keyboard handling

    @objc private func keyboardDidShow(notification: Notification) {

        initialEdgeInsets = self.contentInset

        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardFrame = self.convert(keyboardSize, to: nil)
                let intersect: CGRect = keyboardFrame.intersection(self.bounds)
                if !intersect.isNull {
                    UIView.animate(withDuration: 0.3, animations: {
                        let edgeInset = UIEdgeInsets(top: 64, left: 0, bottom: keyboardFrame.size.height, right: 0)
                        self.contentInset = edgeInset
                        self.scrollIndicatorInsets = edgeInset
                    })
                }
            }
        }
    }

    @objc private func keyboardDidHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentInset = self.initialEdgeInsets
            self.scrollIndicatorInsets = self.initialEdgeInsets
        }
    }
}