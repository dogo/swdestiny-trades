//
//  LoansDetailDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class LoansDetailDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    var lentMe: [CardDTO] = []
    var borrowed: [CardDTO] = []

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

        if indexPath.section == 0 {
            if indexPath.row == lentMe.count {
                cell.textLabel?.text = NSLocalizedString("ADD_CARD", comment: "")
                cell.textLabel?.textColor = UIColor.darkGray
            } else {
                cell.textLabel?.text = nil
                cell.configureCell(cardDTO: lentMe[indexPath.row])
            }
        } else if indexPath.section == 1 {
            if indexPath.row == borrowed.count {
                cell.textLabel?.text = NSLocalizedString("ADD_MY_CARD", comment: "")
                cell.textLabel?.textColor = UIColor.darkGray
            } else {
                cell.textLabel?.text = nil
                cell.configureCell(cardDTO: borrowed[indexPath.row])
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("HAS_LENT_ME", comment: "")
        } else {
            return NSLocalizedString("HAS_BORROWED_MY", comment: "")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == lentMe.count {
            return false
        } else if indexPath.section == 1 && indexPath.row == borrowed.count {
            return false
        }
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return lentMe.count + 1
        } else {
            return borrowed.count + 1
        }
    }

    private func remove(at indexPath: IndexPath) {
        try! RealmManager.shared.realm.write {
            RealmManager.shared.realm.delete(getCard(at: indexPath))
            if indexPath.section == 0 {
                lentMe.remove(at: indexPath.row)
            } else {
                borrowed.remove(at: indexPath.row)
            }
        }
        NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: nil)
    }

    public func getCard(at index: IndexPath) -> CardDTO {
        if index.section == 0 {
            return lentMe[index.row]
        } else {
            return borrowed[index.row]
        }
    }

    public func updateTableViewData(borrowedList: [CardDTO], lentMeList: [CardDTO]) {
        lentMe = lentMeList
        borrowed = borrowedList
        tableView?.reloadData()
    }
}

class LoansDetail: NSObject, UITableViewDelegate {

    weak var delegate: BaseDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
