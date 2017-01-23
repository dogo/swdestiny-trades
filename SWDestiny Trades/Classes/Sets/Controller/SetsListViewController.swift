//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAnalytics

class SetsListViewController: UIViewController {

    fileprivate let setsView = SetsView()

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

        setupNavigationItem()

        setsView.activityIndicator.startAnimating()
        SWDestinyAPI.retrieveSetList(successBlock: { (setsArray: [SetDTO]) in
            self.setsView.setsTableView.updateSetList(setsArray)
            self.setsView.activityIndicator.stopAnimating()
        }) { (error: DataResponse<Any>) in
            self.setsView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            FIRAnalytics.logEvent(withName: "[Error] retrieveSetList", parameters: ["error": failureReason as NSObject])
        }

        setsView.setsTableView.didSelectSet = { [weak self] set in
            self?.navigateToNextController(with: set)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = NSLocalizedString("EXPANSIONS", comment: "")
    }

    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_about"), style: .plain, target: self, action: #selector(aboutButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched(_:)))
    }

    // MARK: - <SetsListViewDelegate>

    func navigateToNextController(with set: SetDTO) {
        let nextController = CardListViewController()
        nextController.setDTO = set
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    // MARK: - UIBarButton Actions

    func aboutButtonTouched(_ sender: Any) {
        let nextController = AboutViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func searchButtonTouched(_ sender: Any) {
        let nextController = SearchListViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}