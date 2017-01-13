//
//  LoanDetailTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailTableView: UITableView, LoansDetailViewDelegate {

    var didSelectCard: ((CardDTO) -> Void)?
    var didSelectAddItem: ((Bool) -> Void)?

    fileprivate var tableViewDatasource: LoansDetailDatasource?
    let loanDetail = LoansDetail()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        loanDetail.delegate = self
        tableViewDatasource = LoansDetailDatasource(tableView: self, delegate: loanDetail)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(borrowedList: [CardDTO], lentMeList: [CardDTO]) {
        tableViewDatasource?.updateTableViewData(borrowedList: borrowedList, lentMeList: lentMeList)
    }

    // Mark: <LoansDetailViewDelegate>

    internal func didSelectItem(at index: IndexPath) {
        if (index.row == tableViewDatasource?.lentMe.count && index.section == 0) || (index.row == tableViewDatasource?.borrowed.count && index.section == 1) {
            didSelectAddItem?(index.section == 0)
        } else if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card)
        }
    }
}
