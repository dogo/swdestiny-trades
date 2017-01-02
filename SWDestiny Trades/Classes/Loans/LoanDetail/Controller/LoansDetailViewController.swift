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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: path, animated: animated)
        }
    }

    func setupTableView() {
        tableViewDatasource = LoansDetailDatasource(borrowedList: personDTO.borrowed, lentMeList: personDTO.lentMe)
        tableViewDelegate = LoansDetailDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
        self.tableView?.reloadData()
    }

    // MARK: - <LoansDetailViewDelegate>

    internal func didSelectSet(at index: IndexPath) {
        if (index.row == tableViewDatasource?.lentMe.count && index.section == 0) || (index.row == tableViewDatasource?.borrowed.count && index.section == 1) {
            performSegue(withIdentifier: "AddCardSegue", sender: index.section == 0)
        } else {
            performSegue(withIdentifier: "CardDetailsSegue", sender: tableViewDatasource?.getCard(at: index))
        }
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardDetailsSegue" {
            if let nextViewController = segue.destination as? CardDetailViewController {
                nextViewController.cardDTO = sender as? CardDTO
            }
        } else if segue.identifier == "AddCardSegue" {
            if let nextViewController = segue.destination as? AddCardViewController {
                nextViewController.isLentMe = sender as? Bool
                nextViewController.personDTO = personDTO
            }
        }
    }
}
