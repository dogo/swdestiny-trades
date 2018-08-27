//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SetsListViewController: UIViewController {

    fileprivate let setsView = SetsView()
    fileprivate let destinyService = SWDestinyServiceImpl()
    fileprivate lazy var navigator = SetsListNavigator(self.navigationController)

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

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

        setsView.setsTableView.didSelectSet = { [unowned self] set in
            self.navigateToNextController(with: set)
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
        destinyService.retrieveSetList { result in
            switch result {
            case .success(let setList):
                self.setsView.setsTableView.updateSetList(setList)
                self.setsView.endRefreshControl()
                self.setsView.activityIndicator.stopAnimating()
            case .failure(let error):
                self.setsView.endRefreshControl()
                self.setsView.activityIndicator.stopAnimating()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                Analytics.logEvent("retrieveSetList", parameters: ["error": errorMessage])
            }
        }
    }

    // MARK: - <SetsListViewDelegate>

    func navigateToNextController(with set: SetDTO) {
        self.navigator.navigate(to: .cardList(with: set))
    }

    // MARK: - UIBarButton Actions

    @objc
    func aboutButtonTouched(_ sender: Any) {
        self.navigator.navigate(to: .about)
    }

    @objc
    func searchButtonTouched(_ sender: Any) {
        self.navigator.navigate(to: .search)
    }
}
