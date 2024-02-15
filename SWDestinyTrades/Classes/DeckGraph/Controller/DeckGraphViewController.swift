//
//  DeckGraphViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphViewController: UIViewController {

    private let graphView: DeckGraphViewType

    var presenter: DeckGraphPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: DeckGraphViewType = DeckGraphCollectionView()) {
        graphView = view
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

        presenter?.updateCollecionViewData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()
    }
}

extension DeckGraphViewController: DeckGraphViewControllerProtocol {

    func updateCollecionViewData(deck: DeckDTO) {
        graphView.updateCollecionViewData(deck: deck)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}
