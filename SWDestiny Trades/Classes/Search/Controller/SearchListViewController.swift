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

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar!
    var cardsData: [CardDTO] = []
    var filtered: [CardDTO] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search"
        
        CardsAPIClient.retrieveCardList(successBlock: { (cardsArray: Array<CardDTO>) in
            self.cardsData = cardsArray
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CardDetailsSegue", sender: filtered[indexPath.row])
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardSearchCell.cellIdentifier(), for: indexPath) as? CardSearchCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(cardDTO: filtered[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }

    // MARK: - <UISearchBarDelegate>

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = cardsData.filter({ (card) -> Bool in
            let tmp: String = card.name
            return tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil
        })
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
