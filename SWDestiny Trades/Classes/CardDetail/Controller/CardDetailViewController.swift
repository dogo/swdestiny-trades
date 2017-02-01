//
//  CardDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import ImageSlideshow

class CardDetailViewController: UIViewController {

    fileprivate let cardView = CardView()
    fileprivate var cards = [CardDTO]()
    fileprivate var cardDTO: CardDTO
    fileprivate var kingfisherSource = [KingfisherSource]()

    // MARK: - Life Cycle

    init(cardList: [CardDTO], selected: CardDTO) {
        cardDTO = selected
        cards = cardList
        super.init(nibName: nil, bundle: nil)

        for card in cardList {
            kingfisherSource.append(KingfisherSource(urlString: card.imageUrl, placeholder: UIImage(named: "ic_cardback"))!)
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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))

        cardView.slideshow.setImageInputs(kingfisherSource)

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

    func share(_ sender: UIBarButtonItem) {

        if let shareImage = cardView.slideshow.currentSlideshowItem?.imageView.image {

            let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)

            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .openInIBooks]
            } else {
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            }

            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
}
