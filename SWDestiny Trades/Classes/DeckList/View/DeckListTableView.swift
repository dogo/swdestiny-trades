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

    fileprivate var initialEdgeInsets: UIEdgeInsets = .zero
    fileprivate var tableViewDatasource: DeckListDatasource?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = DeckListDatasource(tableView: self)
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

    func updateTableViewData(decksList: [DeckDTO]) {
        tableViewDatasource?.updateTableViewData(list: decksList)
    }

    func insert(deck: DeckDTO) {
        tableViewDatasource?.insert(deck: deck)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let deck = tableViewDatasource?.getDeck(at: index) {
            didSelectDeck?(deck)
        }
    }

    // MARK: Keyboard handling

    @objc
    private func keyboardDidShow(notification: Notification) {

        initialEdgeInsets = self.contentInset

        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardFrame = self.convert(keyboardSize, to: nil)
                let intersect: CGRect = keyboardFrame.intersection(self.bounds)
                if !intersect.isNull {
                    UIView.animate(withDuration: 0.3) {
                        let edgeInset = UIEdgeInsets(top: 64, left: 0, bottom: keyboardFrame.size.height, right: 0)
                        self.contentInset = edgeInset
                        self.scrollIndicatorInsets = edgeInset
                    }
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

extension DeckListTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
