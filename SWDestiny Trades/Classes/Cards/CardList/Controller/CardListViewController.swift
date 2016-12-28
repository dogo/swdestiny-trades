//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

protocol CardListViewDelegate {
    func didSelectSet(at index: IndexPath)
}

class CardListViewController: UIViewController, CardListViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var tableViewDatasource: CardListDatasource?
    var tableViewDelegate: CardListDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        CardsAPIClient.retrieveCardList(successBlock: { (cardsArray: Array<CardDTO>) in
            self.tableViewDatasource?.sortAndSplitTableData(cardList: cardsArray)
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: path, animated: animated)
        }
    }

    func setupTableView() {
        tableViewDatasource = CardListDatasource()
        tableViewDelegate = CardListDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    // MARK: - <CardListViewDelegate>

    func didSelectSet(at index: IndexPath) {
        self.performSegue(withIdentifier: "CardDetailsSegue", sender: tableViewDatasource?.getSWDCardAt(index: index))
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardDetailsSegue" {
            if let nextViewController = segue.destination as? CardDetailViewController {
                nextViewController.cardDTO = sender as? CardDTO
            }
        }
    }
}
