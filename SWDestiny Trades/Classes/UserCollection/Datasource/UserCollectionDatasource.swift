//
//  UserCollectionDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class UserCollectionDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    fileprivate var userCollection: UserCollectionDTO!
    var collectionList: [CardDTO] = []

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: LoanDetailCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoanDetailCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(cardDTO: card)
            cell.stepperValueChanged = { (value, cell) in
                guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
                if let card = self.getCard(at: indexPath) {
                    do {
                        try RealmManager.shared.realm.write {
                            card.quantity = value
                        }
                    } catch let error as NSError {
                        print("Error opening realm: \(error)")
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return collectionList[index.row]
    }

    public func getCardList() -> [CardDTO] {
        return collectionList
    }

    public func updateTableViewData(collection: UserCollectionDTO) {
        userCollection = collection
        collectionList = Array(userCollection.myCollection)
        tableView?.reloadData()
    }

    // MARK: Sort options

    public func sortAlphabetically() {
        collectionList = Sort.cardsAlphabetically(cardsArray: collectionList)
        tableView?.reloadData()
    }

    public func sortNumerically() {
        collectionList = Sort.cardsByNumber(cardsArray: collectionList)
        tableView?.reloadData()
    }

    public func sortByColor() {
        collectionList = Sort.cardsByColor(cardsArray: collectionList)
        tableView?.reloadData()
    }

    private func remove(at indexPath: IndexPath) {
        do {
            try RealmManager.shared.realm.write {
                if let card = getCard(at: indexPath), let realmIndex = userCollection.myCollection.index(of: card) {
                    userCollection.myCollection.remove(at: realmIndex)
                    collectionList.remove(at: indexPath.row)
                }
            }
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }
}

class UserCollection: NSObject, UITableViewDelegate {

    weak var delegate: BaseDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(index: indexPath)
    }
}
