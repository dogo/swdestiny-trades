//
//  UserCollectionTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class UserCollectionTableView: UITableView {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    var tableViewDatasource: UserCollectionDatasource?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = UserCollectionDatasource(tableView: self)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(collection: UserCollectionDTO) {
        tableViewDatasource?.updateTableViewData(collection: collection)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let datasource = tableViewDatasource {
            if let card = datasource.getCard(at: index) {
                didSelectCard?(datasource.getCardList(), card)
            }
        }
    }

    // MARK: Sort

    func sort(_ selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            tableViewDatasource?.sortAlphabetically()

        case 1:
            tableViewDatasource?.sortNumerically()

        case 2:
            tableViewDatasource?.sortByColor()

        default:
            break
        }
    }
}

extension UserCollectionTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
