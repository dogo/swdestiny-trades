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
        backgroundColor = .blackWhite
        keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    func didSelectRow(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }

    func didSelectAccessory(at index: IndexPath) {
        if let card = tableDatasource?.getCard(at: index) {
            didSelectAccessory?(card)
        }
    }

    // MARK: - <FilterHeaderViewDelegate>

    func didSelectSegment(index: Int) {
        switch index {
        case 0:
            tableDatasource?.updateSearchList([])
            didSelectRemote?()
            reloadData()
        case 1:
            tableDatasource?.updateSearchList([])
            didSelectLocal?()
            reloadData()
        default:
            break
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
