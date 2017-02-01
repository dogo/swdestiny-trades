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
    var cards = [CardDTO]()
    var cardDTO: CardDTO?
    
    var kingfisherSource = [KingfisherSource]()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(cardList: [CardDTO], selected: CardDTO) {
        self.init()
        cards = cardList
        cardDTO = selected
        
        for card in cardList {
            kingfisherSource.append(KingfisherSource(urlString: card.imageUrl)!)
        }
    }


    override func loadView() {
        self.view = cardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        cardView.cardImageView.setImageInputs(kingfisherSource)
        
        cardView.cardImageView.currentPageChanged = { page in
            self.navigationItem.title = self.cards[page].name
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = cardDTO?.name
    }

    func share(_ sender: UIBarButtonItem) {

        if let shareImage = cardView.cardImageView.currentSlideshowItem?.image {

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
