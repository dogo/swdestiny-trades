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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView?
    var setDTO: SetDTO?
    var tableViewDatasource: CardListDatasource?
    var tableViewDelegate: CardListDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = setDTO?.name

        setupTableView()

        activityIndicator.startAnimating()
        CardsAPIClient.retrieveSetCardList(setCode: setDTO!.code.lowercased(), successBlock: { (cardsArray: Array<CardDTO>) in
            self.tableViewDatasource?.sortAndSplitTableData(cardList: cardsArray)
            self.activityIndicator.stopAnimating()
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            self.activityIndicator.stopAnimating()
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
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    // MARK: - <CardListViewDelegate>

    func didSelectSet(at index: IndexPath) {
        navigateToNextController(with: tableViewDatasource?.getSWDCardAt(index: index))
    }

    // MARK: TEMP

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
