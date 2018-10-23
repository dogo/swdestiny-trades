//
//  SearchListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

@objc
protocol SearchDelegate: AnyObject {
    func didSelectRow(at index: IndexPath)

    @objc
    optional func didSelectAccessory(at index: IndexPath)

    @objc
    optional func didSelectSegment(index: Int)
}

class SearchListViewController: UIViewController {

    fileprivate let destinyService = SWDestinyServiceImpl()
    fileprivate let searchView = SearchView()
    fileprivate var cards = [CardDTO]()
    fileprivate lazy var navigator = SearchNavigator(self.navigationController)

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
        destinyService.retrieveAllCards { result in
            switch result {
            case .success(let allCards):
                self.searchView.searchTableView.updateSearchList(allCards)
                self.searchView.activityIndicator.stopAnimating()
                self.cards = allCards
            case .failure(let error):
                self.searchView.activityIndicator.stopAnimating()
                ToastMessages.showNetworkErrorMessage()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                LoggerManager.shared.log(event: .allCards, parameters: ["error": errorMessage])
            }
        }

        searchView.searchTableView.didSelectCard = { [unowned self] card in
            self.navigateToNextController(with: card)
        }

        searchView.searchBar.doingSearch = { [unowned self] query in
            self.searchView.searchTableView.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.search
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(with: cards, card: card))
    }
}
