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

    required init(loanList: List<LoanDTO>) {
        super.init()

        if loanList.count > 0 {
            let lentMe = loanList.filter("hasLentMe == true")
            let borrowedList = loanList.filter("hasLentMe == false")
            print("ds")
        }

        //self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoanDetailCell.cellIdentifier(), for: indexPath) as? LoanDetailCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        if indexPath.row == lentMe.count {
            cell.textLabel?.text = "Add new card..."
            cell.textLabel?.textColor = UIColor.darkGray
        } else {
            cell.configureCell(cardDTO: lentMe[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Has lent me:"
        } else {
            return "Has borrowed my:"
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //tableData.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        } else if editingStyle == UITableViewCellEditingStyle.insert {
            //tableData.append(thingToInsert)
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            if indexPath.row == lentMe.count || indexPath.row == borrowed.count {
                return UITableViewCellEditingStyle.insert
            } else {
                return UITableViewCellEditingStyle.delete
            }
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
