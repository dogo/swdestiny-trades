//
//  AddCardViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardViewController: UIViewController {

    private let addCardView: AddCardViewType

    var presenter: AddCardPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: AddCardViewType = AddCardView()) {
        addCardView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = addCardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.fetchAllCards()

        addCardView.didSelectCard = { [weak self] card in
            self?.presenter?.insert(card: card)
        }

        addCardView.didSelectAccessory = { [weak self] card in
            self?.presenter?.cardDetailButtonTouched(with: card)
        }

        addCardView.doingSearch = { [weak self] query in
            self?.presenter?.doingSearch(query)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.addCard
    }
}

extension AddCardViewController: AddCardViewProtocol {

    func startLoading() {
        addCardView.startLoading()
    }

    func stopLoading() {
        addCardView.stopLoading()
    }

    func updateSearchList(_ cards: [CardDTO]) {
        addCardView.updateSearchList(cards)
    }

    func doingSearch(_ query: String) {
        addCardView.doingSearch(query)
    }

    func showSuccessMessage(card: CardDTO) {
        LoadingHUD.show(.labeledSuccess(title: L10n.added, subtitle: card.name))
    }
}
