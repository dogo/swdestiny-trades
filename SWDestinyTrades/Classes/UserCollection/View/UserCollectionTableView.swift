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

    weak var userCollectionDelegate: UserCollectionProtocol?

    private var tableViewDatasource: UserCollectionDatasource?

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate = self
        backgroundColor = .blackWhite
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(collection: UserCollectionDTO) {
        tableViewDatasource = UserCollectionDatasource(tableView: self, delegate: userCollectionDelegate)
        tableViewDatasource?.updateTableViewData(collection: collection)
    }

    func getCardList() -> [CardDTO]? {
        return tableViewDatasource?.getCardList()
    }

    // MARK: <BaseDelegate>

    func didSelectRowAt(index: IndexPath) {
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
