//
//  UserCollectionTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class UserCollectionTableView: UITableView, BaseDelegate {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    var tableViewDatasource: UserCollectionDatasource?
    let userCollection = UserCollection()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        userCollection.delegate = self
        tableViewDatasource = UserCollectionDatasource(tableView: self, delegate: userCollection)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(collection: [CardDTO]) {
        //tableViewDatasource?.updateTableViewData(deck: collection)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRow(at index: IndexPath) {
//        if let card = tableViewDatasource?.getCard(at: index) {
//            didSelectCard?(tableViewDatasource.getCardList(), card)
//        }
    }
}
