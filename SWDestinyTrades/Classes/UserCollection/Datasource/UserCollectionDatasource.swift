//
//  UserCollectionDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol UserCollectionProtocol: AnyObject {
    func stepperValueChanged(newValue: Int, card: CardDTO)
    func remove(at index: Int)
}

final class UserCollectionDatasource: NSObject, UITableViewDataSource {

    private var tableView: UITableView?
    private var userCollection: UserCollectionDTO?
    private weak var delegate: UserCollectionProtocol?
    private var collectionList: [CardDTO] = []

    required init(tableView: UITableView, delegate: UserCollectionProtocol?) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        tableView.register(cellType: LoanDetailCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoanDetailCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(cardDTO: card)
            cell.stepperValueChanged = { [weak self] value in
                if let card = self?.getCard(at: indexPath) {
                    self?.delegate?.stepperValueChanged(newValue: value, card: card)
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }

    func getCard(at index: IndexPath) -> CardDTO? {
        return collectionList[index.row]
    }

    func getCardList() -> [CardDTO] {
        return collectionList
    }

    func updateTableViewData(collection: UserCollectionDTO?) {
        if let userCollection = collection {
            self.userCollection = userCollection
            collectionList = Array(userCollection.myCollection)
        }
        tableView?.reloadData()
    }

    // MARK: Sort options

    func sortAlphabetically() {
        collectionList = Sort.cardsAlphabetically(cardsArray: collectionList)
        tableView?.reloadData()
    }

    func sortNumerically() {
        collectionList = Sort.cardsByNumber(cardsArray: collectionList)
        tableView?.reloadData()
    }

    func sortByColor() {
        collectionList = Sort.cardsByColor(cardsArray: collectionList)
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        if let card = getCard(at: indexPath), let index = userCollection?.myCollection.index(of: card) {
            delegate?.remove(at: index)
            collectionList.remove(at: indexPath.row)
        }
    }
}
