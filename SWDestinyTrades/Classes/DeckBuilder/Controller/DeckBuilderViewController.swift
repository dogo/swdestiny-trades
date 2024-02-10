//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderViewController: UIViewController {

    private let deckBuilderView: DeckBuilderViewType

    var presenter: DeckBuilderPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: DeckBuilderViewType) {
        deckBuilderView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = deckBuilderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.setupNavigationItems { [weak self] items in
            self?.navigationItem.rightBarButtonItems = items
        }

        deckBuilderView.didSelectCard = { [weak self] list, card in
            self?.presenter?.navigateToCardDetailViewController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()

        presenter?.loadData(deck: nil)
    }
}

extension DeckBuilderViewController: DeckBuilderViewControllerProtocol {

    func updateTableViewData(deck: DeckDTO) {
        deckBuilderView.updateTableViewData(deck: deck)
    }

    func getDeckList() -> [DeckBuilderDatasource.Section]? {
        return deckBuilderView.getDeckList()
    }

    func presentViewController(_ controller: UIViewController, animated: Bool) {
        present(controller, animated: true, completion: nil)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}
