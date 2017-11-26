//
//  CardDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import ImageSlideshow
import PKHUD

class CardDetailViewController: UIViewController {

    fileprivate let cardView = CardView()
    fileprivate var cards = [CardDTO]()
    fileprivate var cardDTO: CardDTO
    fileprivate var imageSource = [InputSource]()

    // MARK: - Life Cycle

    init(cardList: [CardDTO], selected: CardDTO) {
        cardDTO = selected
        cards = cardList
        super.init(nibName: nil, bundle: nil)

        for card in cardList {
            if let remoteSource = KingfisherSource(urlString: card.imageUrl, placeholder: Asset.icCardback.image) {
                imageSource.append(remoteSource)
            } else {
                let localSource = ImageSource(imageString: "ic_404")!
                imageSource.append(localSource)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = cardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        cardView.slideshow.setImageInputs(imageSource)

        if let index = cards.index(of: cardDTO) {
            cardView.slideshow.setCurrentPage(index, animated: true)
        }

        cardView.slideshow.currentPageChanged = { page in
            self.navigationItem.title = self.cards[page].name
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = cardDTO.name
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addToCollectionBarItem = UIBarButtonItem(image: Asset.NavigationBar.icAddCollection.image, style: .plain, target: self, action: #selector(addToCollection))
        self.navigationItem.rightBarButtonItems = [shareBarItem, addToCollectionBarItem]
    }

    @objc func addToCollection() {
        let card = self.cards[cardView.slideshow.currentPage]
        UserCollectionViewController.addToCollection(carDTO: card)
        showSuccessMessage(cardDTO: card)
    }

    private func showSuccessMessage(cardDTO: CardDTO) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.flash(.labeledSuccess(title: L10n.added, subtitle: cardDTO.name), delay: 0.2)
    }

    @objc func share(_ sender: UIBarButtonItem) {

        if let shareImage = cardView.slideshow.currentSlideshowItem?.imageView.image {

            let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)

            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .openInIBooks]
            } else {
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            }

            activityVC.popoverPresentationController?.barButtonItem = sender
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
}
