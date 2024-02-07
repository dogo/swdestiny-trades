//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsListViewController: UIViewController {

    var presenter: SetsPresenterProtocol?
    private let setsView: SetsView

    // MARK: - Life Cycle

    init(setsView: SetsView = SetsView()) {
        self.setsView = setsView
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
        setsView.pullToRefresh.addTarget(self, action: #selector(retrieveSets), for: .valueChanged)
        presenter?.viewDidLoad()

        setsView.didSelectSet = { [weak self] set in
            self?.presenter?.didSelectSet(set)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.expansions
    }

    @objc
    func retrieveSets() {
        presenter?.retrieveSets()
    }

    @objc
    func aboutButtonTouched() {
        presenter?.aboutButtonTouched()
    }

    @objc
    func searchButtonTouched() {
        presenter?.searchButtonTouched()
    }
}

extension SetsListViewController: SetsListViewProtocol {

    func startLoading() {
        setsView.startLoading()
    }

    func stopLoading() {
        setsView.stopLoading()
    }

    func endRefreshControl() {
        setsView.endRefreshControl()
    }

    func updateSetList(_ setList: [SetDTO]) {
        setsView.updateSetList(setList)
    }

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.NavigationBar.icAbout.image, style: .plain, target: self, action: #selector(aboutButtonTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
    }

    func showNetworkErrorMessage() {
        ToastMessages.showNetworkErrorMessage()
    }
}
