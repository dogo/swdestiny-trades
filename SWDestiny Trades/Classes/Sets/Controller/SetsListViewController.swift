//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsListViewController: UIViewController {
    private let setsView = SetsView()
    private let database: DatabaseProtocol?
    private let destinyService: SWDestinyServiceProtocol
    private lazy var navigator = SetsListNavigator(self.navigationController)

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
        view = setsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blackWhite

        setupNavigationItem()

        setsView.pullToRefresh.addTarget(self, action: #selector(retrieveSets(sender:)), for: .valueChanged)

        setsView.activityIndicator.startAnimating()
        retrieveSets(sender: setsView.pullToRefresh)

        setsView.setsTableView.didSelectSet = { [weak self] set in
            self?.navigateToNextController(with: set)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.expansions
    }

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icAbout.image, style: .plain, target: self, action: #selector(aboutButtonTouched(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched(_:)))
    }

    @objc
    func retrieveSets(sender: UIRefreshControl) {
        destinyService.retrieveSetList { [weak self] result in
            self?.setsView.endRefreshControl()
            self?.setsView.activityIndicator.stopAnimating()
            switch result {
            case let .success(setList):
                self?.setsView.setsTableView.updateSetList(setList)
            case let .failure(error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .setsList, parameters: ["error": error.localizedDescription])
            }
        }
    }

    // MARK: - <SetsListViewDelegate>

    func navigateToNextController(with set: SetDTO) {
        navigator.navigate(to: .cardList(database: database, with: set))
    }

    // MARK: - UIBarButton Actions

    @objc
    func aboutButtonTouched(_ sender: Any) {
        navigator.navigate(to: .about)
    }

    @objc
    func searchButtonTouched(_ sender: Any) {
        navigator.navigate(to: .search(database: database))
    }
}
