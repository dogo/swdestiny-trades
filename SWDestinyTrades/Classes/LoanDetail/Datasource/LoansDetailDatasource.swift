//
//  LoansDetailDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol LoansDetailsProtocol: AnyObject {
    func stepperValueChanged(newValue: Int, card: CardDTO)
    func remove(from section: AddCardType, at index: Int)
}

final class LoansDetailDatasource: NSObject, UITableViewDataSource {

    private var tableView: UITableView?
    private var currentPerson: PersonDTO?
    private weak var delegate: LoansDetailsProtocol?
    private var lentMe: [CardDTO] = []
    private var borrowed: [CardDTO] = []

    required init(tableView: UITableView, delegate: LoansDetailsProtocol) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        tableView.register(cellType: LoanDetailCell.self)
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoanDetailCell.self)

        if indexPath.section == 0 {
            configureLentMe(indexPath: indexPath, cell: cell)
        } else if indexPath.section == 1 {
            configureBorrowed(indexPath: indexPath, cell: cell)
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
        if indexPath.section == 0, indexPath.row == lentMe.count {
            return false
        } else if indexPath.section == 1, indexPath.row == borrowed.count {
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
            cell.textLabel?.textColor = .secondaryLabel
        } else {
            cell.quantityStepper.isHidden = false
            cell.textLabel?.text = nil
            cell.configureCell(cardDTO: lentMe[indexPath.row])
            cell.stepperValueChanged = { [weak self] value in
                if let card = self?.getCard(at: indexPath) {
                    self?.delegate?.stepperValueChanged(newValue: value, card: card)
                }
            }
        }
    }

    private func configureBorrowed(indexPath: IndexPath, cell: LoanDetailCell) {
        if indexPath.row == borrowed.count {
            cell.quantityStepper.isHidden = true
            cell.textLabel?.text = L10n.addMyCard
            cell.textLabel?.textColor = .secondaryLabel
        } else {
            cell.quantityStepper.isHidden = false
            cell.textLabel?.text = nil
            cell.configureCell(cardDTO: borrowed[indexPath.row])
            cell.stepperValueChanged = { [weak self] value in
                if let card = self?.getCard(at: indexPath) {
                    self?.delegate?.stepperValueChanged(newValue: value, card: card)
                }
            }
        }
    }

    private func remove(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            lentMe.remove(at: indexPath.row)
            delegate?.remove(from: .lent, at: indexPath.row)
        } else {
            borrowed.remove(at: indexPath.row)
            delegate?.remove(from: .borrow, at: indexPath.row)
        }
        NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: nil)
    }

    func getLentMeCards() -> [CardDTO] {
        return lentMe
    }

    func getBorrowedCards() -> [CardDTO] {
        return borrowed
    }

    func getCard(at index: IndexPath) -> CardDTO? {
        if index.section == 0 {
            return lentMe[index.row]
        }
        return borrowed[index.row]
    }

    func updateTableViewData(person: PersonDTO?) {
        if let currentPerson = person {
            self.currentPerson = currentPerson
            lentMe = Array(currentPerson.lentMe)
            borrowed = Array(currentPerson.borrowed)
        }
        tableView?.reloadData()
    }
}
