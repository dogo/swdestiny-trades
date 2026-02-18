//
//  CardDetailViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import ImageSlideshow
import SwiftUI

@MainActor
@Observable
final class CardDetailViewModel: BaseViewModel {

    var cards: [CardDTO] = []
    var selectedCard: CardDTO
    var currentIndex: Int = 0
    var showingShareSheet = false
    var showingSuccessMessage = false
    var successMessage = ""
    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    var imageInputs: [InputSource] {
        return cards.compactMap { card in
            if let remoteSource = KingfisherSource(urlString: card.imageUrl, placeholder: Asset.icCardback.image) {
                return remoteSource
            } else {
                return ImageSource(image: Asset.icCardback.image)
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
        showToast = false

        toastTitle = L10n.error
        toastMessage = error.localizedDescription
        toastType = .error

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            showToast = true
        }
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
            let results = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)

            let userCollection: UserCollectionDTO = if let existingCollection = results.first {
                existingCollection
            } else {
                try await database.create(
                    UserCollectionDTO.self,
                    value: [:],
                    update: .error
                )
            }

            try await database.update {
                let predicate = NSPredicate(format: "code == %@", card.code)
                if let index = userCollection.myCollection.index(matching: predicate) {
                    let existingCard = userCollection.myCollection[index]
                    existingCard.quantity += 1
                } else {
                    userCollection.myCollection.append(card)
                }
            }

            showToast = false
            toastTitle = L10n.added
            toastMessage = card.name
            toastType = .success

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                showToast = true
            }

            setLoaded()
        } catch {
            handleError(error)
        }
    }

    func shareCard() {
        showingShareSheet = true
    }
}
