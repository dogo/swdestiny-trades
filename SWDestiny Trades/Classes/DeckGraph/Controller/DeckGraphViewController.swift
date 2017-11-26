//
//  DeckGraphViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class DeckGraphViewController: UIViewController {

    fileprivate let deckDTO: DeckDTO
    fileprivate let graphView = GraphView()

    // MARK: - Life Cycle

    init(deck: DeckDTO) {
        deckDTO = deck
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = graphView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.deckGraphCollectionView.updateCollecionViewData(deck: deckDTO)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = L10n.deckStatistics
    }
}
