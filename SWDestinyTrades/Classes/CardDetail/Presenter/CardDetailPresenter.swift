//
//  CardDetailPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 21/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

protocol CardDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func setNavigationTitle()
    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void)
}

final class CardDetailPresenter: CardDetailPresenterProtocol {

    private weak var view: CardDetailViewProtocol?
    private let database: DatabaseProtocol?
    private var cards = [CardDTO]()
    private var cardDTO: CardDTO
    private var imageSource = [InputSource]()

    init(view: CardDetailViewProtocol,
         database: DatabaseProtocol?,
         cardList: [CardDTO],
         selected: CardDTO) {
        self.view = view
        self.database = database
        cards = cardList
        cardDTO = selected
    }

    // MARK: - CardDetailPresenterProtocol

    func viewDidLoad() {
        setupCardCarousel()

        view?.setSlideshowImageInputs(imageSource)

        if let index = cards.firstIndex(of: cardDTO) {
            view?.setCurrentPage(index, animated: true)
        }
    }

    func setNavigationTitle() {
        view?.setNavigationTitle(cards[view?.getCurrentPage() ?? 0].name)
    }

    func setupNavigationItems(completion: ([UIBarButtonItem]?) -> Void) {
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let addToCollectionBarItem = UIBarButtonItem(image: Asset.NavigationBar.icAddCollection.image, style: .plain, target: self, action: #selector(addToCollection))
        completion([shareBarItem, addToCollectionBarItem])
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
    private func addToCollection() {
        let card = cards[view?.getCurrentPage() ?? 0]
        saveToCollection(carDTO: card)
        view?.showSuccessMessage(card: card)
    }

    @objc
    private func share(_ sender: UIBarButtonItem) {
        if let shareImage = view?.getCurrentSlideshowItem()?.imageView.image {
            let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .openInIBooks]
            activityVC.popoverPresentationController?.barButtonItem = sender

            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    // self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
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
                try? self?.database?.save(object: user)
            }
        }
        return user
    }
}
