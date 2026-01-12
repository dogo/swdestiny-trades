//
//  NavigationDestinationBuilder.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

enum AddCardType: Hashable {
    case lent
    case borrow
    case collection
}

enum NavigationDestinationBuilder {

    @ViewBuilder
    static func build(destination: AppDestination) -> some View {
        switch destination {
        case .setsList:
            SetsListView()

        case let .cardList(setDTO):
            CardListView(set: setDTO)

        case let .cardDetail(cards, selectedCard):
            CardDetailView(cards: cards, selectedCard: selectedCard)

        case .search:
            SearchView()

        case .deckList:
            DeckListView()

        case let .deckBuilder(deckDTO):
            DeckBuilderView(deck: deckDTO)

        case let .deckGraph(deckDTO):
            DeckGraphView(deck: deckDTO)

        case let .addToDeck(deckDTO):
            AddToDeckViewWrapper(deckDTO: deckDTO)

        case .peopleList:
            PeopleListView()

        case .newPerson:
            NewPersonViewWrapper()

        case let .loanDetail(personId):
            LoanDetailView(personId: personId)

        case .userCollection:
            UserCollectionView()

        case .addCard:
            let userCollection = getUserCollection()
            AddCardView(context: .collection(userCollection))

        case let .addCardToCollection(userCollection):
            AddCardView(context: .collection(userCollection))

        case let .addCardToPerson(personId, type):
            AddCardView(personId: personId, type: type)

        case .about:
            AboutView()

        case let .webview(url):
            WebViewWrapper(url: url)
        }
    }

    private static func getUserCollection() -> UserCollectionDTO {
        return UserCollectionDTO()
    }

    private static func contextForType(person: PersonDTO, type: AddCardType) -> AddCardContext {
        switch type {
        case .lent:
            return .lentToPerson(person)
        case .borrow:
            return .borrowedFromPerson(person)
        case .collection:
            return .collection(UserCollectionDTO())
        }
    }
}

// MARK: - View Wrappers for UIKit Integration

struct CardListViewWrapper: View {
    let setDTO: SetDTO

    var body: some View {
        CardListView(set: setDTO)
            .navigationTitle(setDTO.name)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct CardDetailViewWrapper: View {
    let cardDTO: CardDTO

    var body: some View {
        CardDetailView(cards: [cardDTO], selectedCard: cardDTO)
            .navigationTitle(cardDTO.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchViewWrapper: View {
    var body: some View {
        SearchView()
            .navigationTitle(L10n.search1)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct DeckListViewWrapper: View {
    var body: some View {
        DeckListView()
            .navigationTitle(L10n.decks1)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct DeckBuilderViewWrapper: View {
    let deckDTO: DeckDTO?

    var body: some View {
        DeckBuilderView(deck: deckDTO)
            .navigationTitle(deckDTO?.name ?? "New Deck")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeckGraphViewWrapper: View {
    let deckDTO: DeckDTO

    var body: some View {
        DeckGraphView(deck: deckDTO)
            .navigationTitle(L10n.deckGraph)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddToDeckViewWrapper: View {
    let deckDTO: DeckDTO
    @Environment(\.dependencyContainer) private var container

    var body: some View {
        AddToDeckView(deck: deckDTO)
    }
}

struct NewPersonViewWrapper: View {
    var body: some View {
        NewPersonView()
            .navigationTitle(L10n.newPerson1)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserCollectionViewWrapper: View {
    var body: some View {
        UserCollectionView()
            .navigationTitle(L10n.myCollection1)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct AddCardViewWrapper: View {
    let setDTO: SetDTO?

    var body: some View {
        let userCollection = getUserCollection()
        AddCardView(context: .collection(userCollection))
            .navigationTitle(L10n.addCard1)
            .navigationBarTitleDisplayMode(.inline)
    }

    private func getUserCollection() -> UserCollectionDTO {
        return UserCollectionDTO()
    }
}
