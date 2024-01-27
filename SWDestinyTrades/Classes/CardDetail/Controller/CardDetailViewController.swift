//
//  CardDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import UIKit

final class CardDetailViewController: UIViewController {

    private let cardView: CardViewType

    var presenter: CardDetailPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: CardViewType = CardView()) {
        cardView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = cardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()

        presenter?.setupNavigationItems { [weak self] items in
            self?.navigationItem.rightBarButtonItems = items
        }

        cardView.currentPageChanged = { [weak self] _ in
            self?.presenter?.setNavigationTitle()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.setNavigationTitle()
    }
}

extension CardDetailViewController: CardDetailViewProtocol {

    func setSlideshowImageInputs(_ imageInputs: [InputSource]) {
        cardView.setSlideshowImageInputs(imageInputs)
    }

    func setCurrentPage(_ page: Int, animated: Bool) {
        cardView.setCurrentPage(page, animated: animated)
    }

    func getCurrentPage() -> Int {
        cardView.getCurrentPage()
    }

    func getCurrentSlideshowItem() -> ImageSlideshowItem? {
        cardView.getCurrentSlideshowItem()
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func showSuccessMessage(card: CardDTO) {
        LoadingHUD.show(.labeledSuccess(title: L10n.added, subtitle: card.name))
    }

    func presentViewController(_ controller: UIViewController, animated: Bool) {
        present(controller, animated: animated)
    }
}
