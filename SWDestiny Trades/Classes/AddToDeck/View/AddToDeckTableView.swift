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

    private let addCardToDeckTable = AddToDeckCardDelegate()
    private var tableDatasource: AddToDeckCardDatasource?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addCardToDeckTable.delegate = self
        tableDatasource = AddToDeckCardDatasource(cards: [], tableView: self, delegate: addCardToDeckTable)
        self.backgroundColor = .white
        self.keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

    // MARK: - <FilterHeaderViewDelegate>

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

    // MARK: - Keyboard handling

    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo: NSDictionary = notification.userInfo as NSDictionary? {
            if let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = keyboardInfo.cgRectValue.size
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                self.contentInset = contentInsets
                self.scrollIndicatorInsets = contentInsets
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.contentInset = .zero
        self.scrollIndicatorInsets = .zero
    }
}
