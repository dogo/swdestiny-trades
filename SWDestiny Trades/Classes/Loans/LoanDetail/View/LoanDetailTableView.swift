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
    fileprivate var tableViewDelegate: LoansDetailDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDelegate = LoansDetailDelegate(self)
        tableViewDatasource = LoansDetailDatasource(tableView: self, delegate: tableViewDelegate!)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let path = indexPathForSelectedRow {
            deselectRow(at: path, animated: true)
        }
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
