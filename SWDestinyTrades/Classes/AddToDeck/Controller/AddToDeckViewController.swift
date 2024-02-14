//
//  AddToDeckViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddToDeckViewController: UIViewController {

    private let addToDeckView: AddToDeckViewType

    var presenter: AddToDeckPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: AddToDeckViewType = AddToDeckView()) {
        addToDeckView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = addToDeckView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.retrieveAllCards()

        addToDeckView.didSelectCard = { [weak self] card in
            self?.presenter?.insert(card: card)
        }

        addToDeckView.didSelectAccessory = { [weak self] card in
            self?.presenter?.navigateToCardDetail(with: card)
        }

        addToDeckView.doingSearch = { [weak self] query in
            self?.presenter?.doingSearch(query)
        }

        addToDeckView.didSelectRemote = { [weak self] in
            self?.presenter?.retrieveAllCards()
        }

        addToDeckView.didSelectLocal = { [weak self] in
            self?.presenter?.loadDataFromRealm()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.addCard
    }
}

extension AddToDeckViewController: AddToDeckViewProtocol {

    func startLoading() {
        addToDeckView.startLoading()
    }

    func stopLoading() {
        addToDeckView.stopLoading()
    }

    func updateSearchList(_ cards: [CardDTO]) {
        addToDeckView.updateSearchList(cards)
    }

    func doingSearch(_ query: String) {
        addToDeckView.doingSearch(query)
    }

    func showSuccessMessage(card: CardDTO, headUpDisplay: HeadUpDisplay?) {
        headUpDisplay?.show(.labeledSuccess(title: L10n.added, subtitle: card.name))
    }
}
