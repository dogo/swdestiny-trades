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
    private let destinyService: SWDestinyService
    private lazy var navigator = SetsListNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(service: SWDestinyService = SWDestinyServiceImpl(), database: DatabaseProtocol?) {
        self.destinyService = service
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = setsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

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

        self.navigationItem.title = L10n.expansions
    }

    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icAbout.image, style: .plain, target: self, action: #selector(aboutButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched(_:)))
    }

    @objc
    func retrieveSets(sender: UIRefreshControl) {
        destinyService.retrieveSetList { [weak self] result in
            self?.setsView.endRefreshControl()
            self?.setsView.activityIndicator.stopAnimating()
            switch result {
            case .success(let setList):
                guard let setList = setList else { return }
                self?.setsView.setsTableView.updateSetList(setList)
            case .failure(let error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .setsList, parameters: ["error": error.localizedDescription])
            }
        }
    }

    // MARK: - <SetsListViewDelegate>

    func navigateToNextController(with set: SetDTO) {
        self.navigator.navigate(to: .cardList(database: self.database, with: set))
    }

    // MARK: - UIBarButton Actions

    @objc
    func aboutButtonTouched(_ sender: Any) {
        self.navigator.navigate(to: .about)
    }

    @objc
    func searchButtonTouched(_ sender: Any) {
        self.navigator.navigate(to: .search(database: self.database))
    }
}
