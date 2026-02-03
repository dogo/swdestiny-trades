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
    }
}

struct CardDetailViewWrapper: View {
    let cardDTO: CardDTO

    var body: some View {
        CardDetailView(cards: [cardDTO], selectedCard: cardDTO)
    }
}

struct SearchViewWrapper: View {
    var body: some View {
        SearchView()
    }
}

struct DeckListViewWrapper: View {
    var body: some View {
        DeckListView()
    }
}

struct DeckBuilderViewWrapper: View {
    let deckDTO: DeckDTO?

    var body: some View {
        DeckBuilderView(deck: deckDTO)
    }
}

struct DeckGraphViewWrapper: View {
    let deckDTO: DeckDTO

    var body: some View {
        DeckGraphView(deck: deckDTO)
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
    }
}

struct UserCollectionViewWrapper: View {
    var body: some View {
        UserCollectionView()
    }
}

struct AddCardViewWrapper: View {
    let setDTO: SetDTO?

    var body: some View {
        let userCollection = getUserCollection()
        AddCardView(context: .collection(userCollection))
    }

    private func getUserCollection() -> UserCollectionDTO {
        return UserCollectionDTO()
    }
}
