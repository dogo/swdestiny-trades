//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

protocol SetsListViewDelegate {
    func didSelectSet(at index: IndexPath)
}

class SetsListViewController: UIViewController, SetsListViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var tableViewDatasource: SetsListDatasource?
    var tableViewDelegate: SetsListDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        SetsAPIClient.retrieveSetList(successBlock: { (setsArray: Array<SetDTO>) in
            self.setupTableView(with: setsArray)
        }) { (error: DataResponse<Any>) in
          print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = self.tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRow(at: path, animated: animated)
        }
    }

    func setupTableView(with sets: [SetDTO]) {
        tableViewDelegate = SetsListDelegate(self)
        tableViewDatasource = SetsListDatasource(sets: sets, tableView: self.tableView!, delegate: tableViewDelegate!)
    }

    // MARK: - <SetsListViewDelegate>
    
    func didSelectSet(at index: IndexPath) {
        let selectedSet = tableViewDatasource?.swdSets[(tableViewDatasource?.sectionLetters[index.section])!]?[index.row]
        self.performSegue(withIdentifier: "ShowSetSegue", sender: selectedSet)
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSetSegue" {
            if let nextViewController = segue.destination as? CardListViewController {
                nextViewController.navigationItem.title = (sender as? SetDTO)?.name
            }
        }
    }
}
