//
//  DeckListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListTableView: UITableView, DeckListViewType {

    var didSelectDeck: ((DeckDTO) -> Void)?

    weak var deckListDelegate: DeckListProtocol?

    private var tableViewDatasource: DeckListDatasource?

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate = self
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
        tableViewDatasource = DeckListDatasource(tableView: self, delegate: deckListDelegate)
        tableViewDatasource?.updateTableViewData(list: decksList)
    }

    func refreshData() {
        reloadData()
    }

    func insert(deck: DeckDTO) {
        tableViewDatasource?.insert(deck: deck)
    }

    // MARK: - <BaseDelegate>

    func didSelectRowAt(index: IndexPath) {
        if let deck = tableViewDatasource?.getDeck(at: index) {
            didSelectDeck?(deck)
        }
    }

    // MARK: - Keyboard handling

    @objc
    private func keyboardWillShow(notification: NSNotification) {
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
    private func keyboardWillHide(notification: NSNotification) {
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
