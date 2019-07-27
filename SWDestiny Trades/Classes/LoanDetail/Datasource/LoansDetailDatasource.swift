//
//  LoansDetailDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class LoansDetailDatasource: NSObject, UITableViewDataSource {

    private var tableView: UITableView?
    private var currentPerson: PersonDTO?
    var lentMe: [CardDTO] = []
    var borrowed: [CardDTO] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: LoanDetailCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoanDetailCell.self)

        if indexPath.section == 0 {
            self.configureLentMe(indexPath: indexPath, cell: cell)
        } else if indexPath.section == 1 {
            self.configureBorrowed(indexPath: indexPath, cell: cell)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return L10n.hasLentMe
        }
        return L10n.hasBorrowedMy
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
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
        }
        return borrowed.count + 1
    }

    private func configureLentMe(indexPath: IndexPath, cell: LoanDetailCell) {
        if indexPath.row == lentMe.count {
            cell.quantityStepper.isHidden = true
            cell.textLabel?.text = L10n.addCard.appending("...")
            cell.textLabel?.textColor = .darkGray
        } else {
            cell.quantityStepper.isHidden = false
            cell.textLabel?.text = nil
            cell.configureCell(cardDTO: lentMe[indexPath.row])
            cell.stepperValueChanged = { [weak self] value, cell in
                guard let self = self else { return }
                guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
                if let card = self.getCard(at: indexPath) {
                    do {
                        try RealmManager.shared.realm.write {
                            card.quantity = value
                        }
                    } catch let error as NSError {
                        print("Error opening realm: \(error)")
                    }
                }
            }
        }
    }

    private func configureBorrowed(indexPath: IndexPath, cell: LoanDetailCell) {
        if indexPath.row == borrowed.count {
            cell.quantityStepper.isHidden = true
            cell.textLabel?.text = L10n.addMyCard
            cell.textLabel?.textColor = .darkGray
        } else {
            cell.quantityStepper.isHidden = false
            cell.textLabel?.text = nil
            cell.configureCell(cardDTO: borrowed[indexPath.row])
            cell.stepperValueChanged = { [weak self] value, cell in
                guard let self = self else { return }
                guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
                if let card = self.getCard(at: indexPath) {
                    do {
                        try RealmManager.shared.realm.write {
                            card.quantity = value
                        }
                    } catch let error as NSError {
                        print("Error opening realm: \(error)")
                    }
                }
            }
        }
    }

    private func remove(at indexPath: IndexPath) {
        do {
            try RealmManager.shared.realm.write { [weak self] in
                if indexPath.section == 0 {
                    self?.lentMe.remove(at: indexPath.row)
                    self?.currentPerson?.lentMe.remove(at: indexPath.row)
                } else {
                    self?.borrowed.remove(at: indexPath.row)
                    self?.currentPerson?.borrowed.remove(at: indexPath.row)
                }
            }
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: nil)
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        if index.section == 0 {
            return lentMe[index.row]
        }
        return borrowed[index.row]
    }

    public func updateTableViewData(person: PersonDTO?) {
        if let currentPerson = person {
            self.currentPerson = currentPerson
            lentMe = Array(currentPerson.lentMe)
            borrowed = Array(currentPerson.borrowed)
        }
        tableView?.reloadData()
    }
}
