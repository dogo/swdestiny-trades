//
//  CardDetailViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class CardDetailViewModel: BaseViewModel {

    var cards: [CardDTO] = []
    var selectedCard: CardDTO
    var currentIndex: Int = 0
    var showingSuccessMessage = false
    var successMessage = ""
    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    var imageLoader: ImageLoadingService {
        dependencyContainer.resolve(type: ImageLoadingService.self)
    }

    var imageSources: [ImageSource] {
        return cards.map { card in
            if let url = URL(string: card.imageUrl),
               let scheme = url.scheme?.lowercased(),
               scheme == "http" || scheme == "https" {
                return .remote(url)
            } else {
                return .local(Asset.icCardback.image)
            }
        }
    }

    var currentCard: CardDTO {
        guard currentIndex < cards.count else { return selectedCard }
        return cards[currentIndex]
    }

    init(cards: [CardDTO], selectedCard: CardDTO, dependencyContainer: DependencyContainer = .shared) {
        self.cards = cards
        self.selectedCard = selectedCard
        super.init(dependencyContainer: dependencyContainer)

        if let index = cards.firstIndex(of: selectedCard) {
            currentIndex = index
        }
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        cards = []
        selectedCard = CardDTO()
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        toastTitle = L10n.error
        toastMessage = error.localizedDescription
        toastType = .error
        showToast = true
    }

    func updateCurrentIndex(_ index: Int) {
        guard index < cards.count else { return }
        currentIndex = index
    }

    func addToCollection() async {
        let card = currentCard

        setLoading(true)
        defer { setLoading(false) }

        do {
            try Task.checkCancellation()

            let results = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)

            try Task.checkCancellation()

            let userCollection: UserCollectionDTO = if let existingCollection = results.first {
                existingCollection
            } else {
                try await database.create(
                    UserCollectionDTO.self,
                    value: [:],
                    update: .error
                )
            }

            try Task.checkCancellation()

            try await database.update {
                let predicate = NSPredicate(format: "code == %@", card.code)
                if let index = userCollection.myCollection.index(matching: predicate) {
                    let existingCard = userCollection.myCollection[index]
                    existingCard.quantity += 1
                } else {
                    let cardCopy = CardDTO(value: card)
                    cardCopy.id = NSUUID().uuidString
                    userCollection.myCollection.append(cardCopy)
                }
            }

            toastTitle = L10n.added
            toastMessage = card.name
            toastType = .success
            showToast = true

            setLoaded()
        } catch is CancellationError {
            // Silently cancel
        } catch {
            handleError(error)
        }
    }
}
