//
//  SearchListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

class SearchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar!
    var searchIsActive: Bool = false
    var cardsData: [CardDTO] = []
    var filtered: [CardDTO] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search"

        self.activityIndicator.startAnimating()
        CardsAPIClient.retrieveAllCards(successBlock: { (cardsArray: Array<CardDTO>) in
            self.cardsData = cardsArray
            self.filtered = cardsArray
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CardDetailsSegue", sender: searchIsActive ? filtered[indexPath.row] : cardsData[indexPath.row])
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardSearchCell.cellIdentifier(), for: indexPath) as? CardSearchCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(cardDTO: searchIsActive ? filtered[indexPath.row] : cardsData[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsActive {
            return filtered.count
        }
        return cardsData.count
    }

    // MARK: - <UISearchBarDelegate>

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.trim().isEmpty {
            searchIsActive = false
        } else {
            filtered = cardsData.filter({ (card) -> Bool in
                return card.name.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil
            })
            searchIsActive = true
        }
        tableView?.reloadData()
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
