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

final class SearchListViewController: UIViewController {
    private let destinyService: SWDestinyServiceProtocol
    private let database: DatabaseProtocol?
    private let searchView: SearchViewType = SearchView()
    private var cards = [CardDTO]()
    private lazy var navigator = SearchNavigator(self)

    // MARK: - Life Cycle

    init(service: SWDestinyServiceProtocol = SWDestinyService(), database: DatabaseProtocol?) {
        destinyService = service
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.didSelectCard = { [weak self] card in
            self?.navigateToNextController(with: card)
        }

        searchView.doingSearch = { [weak self] query in
            self?.search(query: query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.search
    }

    private func search(query: String) {
        searchView.startLoading()
        Task { [weak self] in
            guard let self else { return }

            defer {
                self.searchView.stopLoading()
            }

            do {
                let allCards = try await destinyService.search(query: query)
                searchView.updateSearchList(allCards)
                cards = allCards
            } catch {
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .allCards, parameters: ["error": error.localizedDescription])
            }
        }
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cards, card: card))
    }
}
