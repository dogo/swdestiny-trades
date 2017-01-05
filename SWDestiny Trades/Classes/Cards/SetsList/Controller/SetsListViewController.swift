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
        self.performSegue(withIdentifier: "ShowSetSegue", sender: tableViewDatasource?.getSWDSetAt(index: index))
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSetSegue" {
            if let nextViewController = segue.destination as? CardListViewController {
                nextViewController.setDTO = (sender as? SetDTO)
            }
        }
    }

    // MARK: - TEMP

    @IBAction func navigateToNextController(_ sender: Any) {
        let nextController = AboutViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
