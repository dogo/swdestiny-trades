//
//  UserCollectionViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class UserCollectionViewController: UIViewController {

    private let userCollectionView: UserCollectionViewType

    var presenter: UserCollectionPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: UserCollectionViewType = UserCollectionTableView()) {
        userCollectionView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = userCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.setupNavigationItems { leftItems, rightItems in
            navigationItem.rightBarButtonItems = leftItems
            navigationItem.leftBarButtonItems = rightItems
        }

        userCollectionView.didSelectCard = { [weak self] list, card in
            self?.presenter?.navigateToCardDetail(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()

        presenter?.loadDataFromRealm()
    }
}

extension UserCollectionViewController: UserCollectionViewControllerProtocol {

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func updateTableViewData(collection: UserCollectionDTO) {
        userCollectionView.updateTableViewData(collection: collection)
    }

    func sort(_ selectedIndex: Int) {
        userCollectionView.sort(selectedIndex)
    }

    func getCardList() -> [CardDTO]? {
        userCollectionView.getCardList()
    }

    func presentViewController(_ controller: UIViewController, animated: Bool) {
        present(controller, animated: animated, completion: nil)
    }
}
