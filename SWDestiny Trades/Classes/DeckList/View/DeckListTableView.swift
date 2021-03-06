//
//  DeckListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListTableView: UITableView {
    var didSelectDeck: ((DeckDTO) -> Void)?

    private var tableViewDatasource: DeckListDatasource?

    required init(frame: CGRect = .zero, style: UITableView.Style = .plain, delegate: DeckListProtocol) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = DeckListDatasource(tableView: self, delegate: delegate)
        backgroundColor = .blackWhite
        keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(decksList: [DeckDTO]) {
        tableViewDatasource?.updateTableViewData(list: decksList)
    }

    func insert(deck: DeckDTO) {
        tableViewDatasource?.insert(deck: deck)
    }

    // MARK: - <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let deck = tableViewDatasource?.getDeck(at: index) {
            didSelectDeck?(deck)
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

extension DeckListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
