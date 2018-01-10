//
//  AddToDeckTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 29/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddToDeckTableView: UITableView, SearchDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAccessory: ((CardDTO) -> Void)?
    var doingSearch: ((String) -> Void)?
    var didSelectRemote: (() -> Void)?
    var didSelectLocal: (() -> Void)?

    fileprivate let addCardToDeckTable = AddToDeckCardDelegate()
    fileprivate var tableDatasource: AddToDeckCardDatasource?
    fileprivate var initialEdgeInsets: UIEdgeInsets = .zero

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        addCardToDeckTable.delegate = self
        tableDatasource = AddToDeckCardDatasource(cards: [], tableView: self, delegate: addCardToDeckTable)
        self.backgroundColor = .white

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

    func doingSearch(_ query: String) {
        tableDatasource?.doingSearch(query)
    }

    func updateSearchList(_ cards: [CardDTO]) {
        tableDatasource?.updateSearchList(cards)
    }

    // MARK: <SearchDelegate>

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

    // MARK: <FilterHeaderViewDelegate>

    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            tableDatasource?.updateSearchList([])
            didSelectRemote?()
            self.reloadData()
        case 1:
            tableDatasource?.updateSearchList([])
            didSelectLocal?()
            self.reloadData()
        default:
            break
        }
    }

    // MARK: Keyboard handling

    @objc
    private func keyboardDidShow(notification: Notification) {

        initialEdgeInsets = self.contentInset

        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardFrame = self.convert(keyboardSize, to: nil)
                UIView.animate(withDuration: 0.3, animations: {
                    let tabBarHeight: CGFloat = 49.0
                    let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height - tabBarHeight, right: 0)
                    self.contentInset = edgeInset
                    self.scrollIndicatorInsets = edgeInset
                })
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
