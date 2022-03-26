//
//  AddCardTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 06/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardTableView: UITableView, SearchDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?

    var tableDatasource: AddCardDatasource?
    let addCardTable = AddCardTableDelegate()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addCardTable.delegate = self
        tableDatasource = AddCardDatasource(cards: [], tableView: self, delegate: addCardTable)
        backgroundColor = .blackWhite
        keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doingSearch(_ query: String) {
        tableDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        tableDatasource?.updateSearchList(cards)
    }

    // MARK: - <SearchDelegate>

    internal func didSelectRow(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }

    internal func didSelectAccessory(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectAccessory?(card)
        }
    }

    // MARK: - Keyboard handling

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
