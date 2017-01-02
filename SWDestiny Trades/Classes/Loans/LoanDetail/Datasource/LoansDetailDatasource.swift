//
//  LoansDetailDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

class LoansDetailDatasource: NSObject, UITableViewDataSource {

    var lentMe: [CardDTO] = []
    var borrowed: [CardDTO] = []

    required init(borrowedList: List<CardDTO>, lentMeList: List<CardDTO>) {
        super.init()
        updateTableViewData(borrowedList: borrowedList, lentMeList: lentMeList)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoanDetailCell.cellIdentifier(), for: indexPath) as? LoanDetailCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        if indexPath.section == 0 {
            if indexPath.row == lentMe.count {
                cell.textLabel?.text = "Add their card..."
                cell.textLabel?.textColor = UIColor.darkGray
            } else {
                cell.textLabel?.text = nil
                cell.configureCell(cardDTO: lentMe[indexPath.row])
            }
        } else if indexPath.section == 1 {
            if indexPath.row == borrowed.count {
                cell.textLabel?.text = "Add my card..."
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
            return "Has lent me:"
        } else {
            return "Has borrowed my:"
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return lentMe.count + 1
        } else {
            return borrowed.count + 1
        }
    }

    private func remove(at indexPath: IndexPath) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(getCard(at: indexPath))
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

    public func updateTableViewData(borrowedList: List<CardDTO>, lentMeList: List<CardDTO>) {
        lentMe = Array(lentMeList)
        borrowed = Array(borrowedList)
    }
}

class LoansDetailDelegate: NSObject, UITableViewDelegate {

    private let delegate: LoansDetailViewDelegate

    init(_ delegate: LoansDetailViewDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectSet(at: indexPath)
    }
}
