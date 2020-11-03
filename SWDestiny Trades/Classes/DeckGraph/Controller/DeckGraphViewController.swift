//
//  DeckGraphViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphViewController: UIViewController {
    private let deckDTO: DeckDTO
    private let graphView = DeckGraphCollectionView()

    // MARK: - Life Cycle

    init(deck: DeckDTO) {
        deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = graphView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.updateCollecionViewData(deck: deckDTO)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.deckStatistics
    }
}
