//
//  LoanDetailTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoanDetailTableView: UITableView, LoanDetailViewType {

    var didSelectCard: ((CardDTO, AddCardType) -> Void)?
    var didSelectAddItem: ((AddCardType) -> Void)?
    
    weak var loansDetailDelegate: LoansDetailsProtocol?
    
    private var tableViewDatasource: LoansDetailDatasource?

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        self.delegate = self
        backgroundColor = .blackWhite
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewData(person: PersonDTO) {
        tableViewDatasource = LoansDetailDatasource(tableView: self, delegate: loansDetailDelegate)
        tableViewDatasource?.updateTableViewData(person: person)
    }

    // MARK: <BaseDelegate>

    func didSelectRowAt(index: IndexPath) {
        let lentCount = tableViewDatasource?.getLentMeCards().count ?? 0
        let borrowedCount = tableViewDatasource?.getBorrowedCards().count ?? 0

        if (index.row == lentCount && index.section == 0) || (index.row == borrowedCount && index.section == 1) {
            didSelectAddItem?(index.section == 0 ? .lent : .borrow)
        } else if let card = tableViewDatasource?.getCard(at: index) {
            didSelectCard?(card, index.section == 0 ? .lent : .borrow)
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
