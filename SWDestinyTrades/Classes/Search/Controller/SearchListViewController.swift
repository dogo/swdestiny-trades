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

    private let searchView: SearchViewType

    var presenter: SearchLisPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: SearchViewType = SearchView()) {
        searchView = view
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
            self?.presenter?.navigateToCardDetail(with: card)
        }

        searchView.doingSearch = { [weak self] query in
            self?.presenter?.search(query: query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()
    }
}

extension SearchListViewController: SearchListViewControllerProtocol {

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func startLoading() {
        searchView.startLoading()
    }

    func stopLoading() {
        searchView.stopLoading()
    }

    func updateTableViewData(_ cardList: [CardDTO]) {
        searchView.updateSearchList(cardList)
    }

    func showNetworkErrorMessage() {
        ToastMessages.showNetworkErrorMessage()
    }
}
