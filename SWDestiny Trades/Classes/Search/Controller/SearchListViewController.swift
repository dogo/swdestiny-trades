//
//  SearchListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAnalytics

@objc protocol SearchDelegate: class {
    func didSelectRow(at index: IndexPath)
    @objc optional func didSelectAccessory(at index: IndexPath)
}

class SearchListViewController: UIViewController {

    fileprivate let searchView = SearchView()
    fileprivate var cards = [CardDTO]()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.activityIndicator.startAnimating()
        SWDestinyAPI.retrieveAllCards(successBlock: { (cardsArray: [CardDTO]) in
            self.searchView.searchTableView.updateSearchList(cardsArray)
            self.cards = cardsArray
            self.searchView.activityIndicator.stopAnimating()
        }) { (error: DataResponse<Any>) in
            self.searchView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            FIRAnalytics.logEvent(withName: "retrieveAllCards", parameters: ["error": failureReason as NSObject])
        }

        searchView.searchTableView.didSelectCard = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        searchView.searchBar.doingSearch = { [weak self] query in
            self?.searchView.searchTableView.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = NSLocalizedString("SEARCH", comment: "")
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cards, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
