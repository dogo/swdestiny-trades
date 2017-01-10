//
//  SearchListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchDelegate {
    func didSelectCard(at index: IndexPath)
}

class SearchListViewController: UIViewController {

    let searchView = SearchView()

    // MARK: - Life Cycle

    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search"

        searchView.activityIndicator.startAnimating()
        CardsAPIClient.retrieveAllCards(successBlock: { (cardsArray: Array<CardDTO>) in
            self.searchView.searchTableView.updateSearchList(cardsArray)
            self.searchView.activityIndicator.stopAnimating()
        }) { (error: DataResponse<Any>) in
            self.searchView.activityIndicator.stopAnimating()
            print(error)
        }

        searchView.searchTableView.didSelectCard = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        searchView.searchBar.doingSearch = { [weak self] query in
            self?.searchView.searchTableView.doingSearch(query)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchBar.becomeFirstResponder()
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
