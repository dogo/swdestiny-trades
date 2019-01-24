//
//  LoanDetailTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailTableView: UITableView {

    var didSelectCard: ((CardDTO, Bool) -> Void)?
    var didSelectAddItem: ((AddCardType) -> Void)?

    fileprivate var tableViewDatasource: LoansDetailDatasource?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = LoansDetailDatasource(tableView: self)
        self.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(person: PersonDTO) {
        tableViewDatasource?.updateTableViewData(person: person)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if (index.row == tableViewDatasource?.lentMe.count && index.section == 0) || (index.row == tableViewDatasource?.borrowed.count && index.section == 1) {
            didSelectAddItem?(index.section == 0 ? .lent : .borrow)
        } else if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card, index.section == 0)
        }
    }
}

extension LoanDetailTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
