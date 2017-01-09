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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView?
    var tableViewDatasource: SetsListDatasource?
    var tableViewDelegate: SetsListDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        activityIndicator.startAnimating()
        SetsAPIClient.retrieveSetList(successBlock: { (setsArray: Array<SetDTO>) in
            self.tableViewDatasource?.sortAndSplitTableData(setList: setsArray)
            self.activityIndicator.stopAnimating()
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            self.activityIndicator.stopAnimating()
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = self.tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRow(at: path, animated: animated)
        }
    }

    func setupTableView() {
        tableViewDatasource = SetsListDatasource()
        tableViewDelegate = SetsListDelegate(self)
        self.tableView?.dataSource = tableViewDatasource
        self.tableView?.delegate = tableViewDelegate
    }

    // MARK: - <SetsListViewDelegate>

    func didSelectSet(at index: IndexPath) {
        let nextController = CardListViewController()
        nextController.setDTO = tableViewDatasource?.getSWDSetAt(index: index)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    // MARK: - TEMP

    @IBAction func navigateToNextController(_ sender: Any) {
        let nextController = AboutViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    @IBAction func searchButtonTouched(_ sender: Any) {
        let nextController = SearchListViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
