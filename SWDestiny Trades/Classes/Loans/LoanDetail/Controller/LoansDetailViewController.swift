//
//  LoansDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol LoansDetailViewDelegate {
    func didSelectSet(at: IndexPath)
}

class LoansDetailViewController: UIViewController, LoansDetailViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var personDTO: PersonDTO!
    var tableViewDatasource: LoansDetailDatasource?
    var tableViewDelegate: LoansDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "\(personDTO.name) \(personDTO.lastName)"

        setupTableView()
    }

    func setupTableView() {
        tableViewDatasource = LoansDetailDatasource(loanList: personDTO.loans)
        tableViewDelegate = LoansDetailDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    internal func didSelectSet(at index: IndexPath) {
        if index.row == tableViewDatasource?.lentMe.count || index.row == tableViewDatasource?.borrowed.count {
            print("if")
        } else {
            print("else")
        }
    }
}
