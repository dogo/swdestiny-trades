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

    private let cardView = CardView()
    private let database: DatabaseProtocol?
    private var cards = [CardDTO]()
    private var cardDTO: CardDTO
    private var imageSource = [InputSource]()
    private var showingBack = false

    // MARK: - Life Cycle

    init(database: DatabaseProtocol?, cardList: [CardDTO], selected: CardDTO) {
        self.database = database
        cardDTO = selected
        cards = cardList
        super.init(nibName: nil, bundle: nil)
        setupCardCarousel()
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

        setupNavigationItem()

        cardView.slideshow.setImageInputs(imageSource)

        if let index = cards.firstIndex(of: cardDTO) {
            cardView.slideshow.setCurrentPage(index, animated: true)
        }

        cardView.slideshow.currentPageChanged = { [weak self] page in
            if let card = self?.cards[page] {
                self?.navigationItem.title = card.name
                self?.cardDTO = card
            }
        }

        cardView.slideshow.willBeginDragging = {
            if self.showingBack {
                self.didTap()
            }
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetailViewController.didTap))
        // gestureRecognizer.numberOfTapsRequired = 2
        cardView.slideshow.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = cardDTO.name
    }

    private func setupNavigationItem() {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addToCollectionBarItem = UIBarButtonItem(image: Asset.NavigationBar.icAddCollection.image, style: .plain, target: self, action: #selector(addToCollection))
        navigationItem.rightBarButtonItems = [shareBarItem, addToCollectionBarItem]
    }

    private func setupCardCarousel() {
        for card in cards {
            if let remoteSource = KingfisherSource(urlString: card.imageUrl, placeholder: Asset.icCardback.image) {
                imageSource.append(remoteSource)
            } else {
                let localSource = ImageSource(image: Asset.ic404.image)
                imageSource.append(localSource)
            }
        }
    }

    @objc
    func addToCollection() {
        let card = cards[cardView.slideshow.currentPage]
        saveToCollection(carDTO: card)
        showSuccessMessage(cardDTO: card)
    }

    private func saveToCollection(carDTO: CardDTO) {
        let user = getUserCollection()
        try? database?.update {
            let predicate = NSPredicate(format: "code == %@", carDTO.code)
            if let index = user.myCollection.index(matching: predicate) {
                let newCard = user.myCollection[index]
                newCard.quantity += 1
            } else {
                user.myCollection.append(carDTO)
            }
        }
    }

    private func getUserCollection() -> UserCollectionDTO {
        var user = UserCollectionDTO()
        try? database?.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { [weak self] results in
            if let userCollection = results.first {
                user = userCollection
            } else {
                self?.createDatabase(object: user)
            }
        }
        return user
    }

    private func createDatabase(object: UserCollectionDTO) {
        try? database?.save(object: object)
    }

    private func showSuccessMessage(cardDTO: CardDTO) {
        LoadingHUD.show(.labeledSuccess(title: L10n.added, subtitle: cardDTO.name))
    }

    @objc
    func share(_ sender: UIBarButtonItem) {
        if let shareImage = cardView.slideshow.currentSlideshowItem?.imageView.image {
            let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .openInIBooks]
            activityVC.popoverPresentationController?.barButtonItem = sender

            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }

    @objc
    func didTap() {
        let toView = showingBack ? cardView.slideshow.currentSlideshowItem?.imageView : cardView.backView
        let fromView = showingBack ? cardView.backView : cardView.slideshow.currentSlideshowItem?.imageView
        cardView.backView.configureCardView(cardDTO: cardDTO)
        if let fromView = fromView, let toView = toView {
            UIView.transition(from: fromView, to: toView, duration: 1, options: .transitionFlipFromRight, completion: nil)
        }
        showingBack.toggle()
    }
}
