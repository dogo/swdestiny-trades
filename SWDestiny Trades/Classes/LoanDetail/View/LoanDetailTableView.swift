//
//  LoanDetailTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailTableView: UITableView, BaseDelegate {

    var didSelectCard: ((CardDTO, Bool) -> Void)?
    var didSelectAddItem: ((AddCardType) -> Void)?

    fileprivate var tableViewDatasource: LoansDetailDatasource?
    fileprivate let loanDetail = LoansDetail()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        loanDetail.delegate = self
        tableViewDatasource = LoansDetailDatasource(tableView: self, delegate: loanDetail)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(person: PersonDTO) {
        tableViewDatasource?.updateTableViewData(person: person)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if (index.row == tableViewDatasource?.lentMe.count && index.section == 0) || (index.row == tableViewDatasource?.borrowed.count && index.section == 1) {
            didSelectAddItem?(index.section == 0 ? AddCardType.lent : AddCardType.Borrow)
        } else if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card, index.section == 0)
        }
    }
}
