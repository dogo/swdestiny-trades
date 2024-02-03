//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListViewController: UIViewController {

    private let cardListView: CardListViewType

    var presenter: CardListPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: CardListViewType = CardListView()) {
        cardListView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = cardListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.retrieveCardsList()

        cardListView.didSelectCard = { [weak self] list, card in
            self?.presenter?.didSelectCard(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // navigationItem.title = setDTO.name
    }
}
