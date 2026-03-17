//
//  NavigationDestinationBuilder.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

enum NavigationDestinationBuilder {

    @ViewBuilder
    static func build(destination: AppDestination) -> some View {
        switch destination {
        case .setsList, .cardList, .cardDetail, .search:
            buildCardDestination(destination)
        case .deckList, .deckBuilder, .deckGraph, .addToDeck:
            buildDeckDestination(destination)
        case .peopleList, .newPerson, .loanDetail:
            buildPeopleDestination(destination)
        case .userCollection, .addCard, .addCardToCollection, .addCardToPerson:
            buildCollectionDestination(destination)
        case .about, .webview:
            buildMiscDestination(destination)
        }
    }

    @ViewBuilder
    private static func buildCardDestination(_ destination: AppDestination) -> some View {
        switch destination {
        case .setsList:
            SetsListView()
        case let .cardList(setDTO):
            CardListView(set: setDTO)
        case let .cardDetail(cards, selectedCard, showAddToCollection):
            CardDetailView(cards: cards, selectedCard: selectedCard, showAddToCollection: showAddToCollection)
        case .search:
            SearchView()
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private static func buildDeckDestination(_ destination: AppDestination) -> some View {
        switch destination {
        case .deckList:
            DeckListView()
        case let .deckBuilder(deckDTO):
            DeckBuilderView(deck: deckDTO)
        case let .deckGraph(deckDTO):
            DeckGraphView(deck: deckDTO)
        case let .addToDeck(deckDTO):
            AddToDeckView(deck: deckDTO)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private static func buildPeopleDestination(_ destination: AppDestination) -> some View {
        switch destination {
        case .peopleList:
            PeopleListView()
        case .newPerson:
            NewPersonView()
        case let .loanDetail(personId):
            LoanDetailView(personId: personId)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private static func buildCollectionDestination(_ destination: AppDestination) -> some View {
        switch destination {
        case .userCollection:
            UserCollectionView()
        case .addCard:
            AddCardView(context: .collection(UserCollectionDTO()))
        case let .addCardToCollection(userCollection):
            AddCardView(context: .collection(userCollection))
        case let .addCardToPerson(personId, type):
            AddCardView(personId: personId, type: type)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private static func buildMiscDestination(_ destination: AppDestination) -> some View {
        switch destination {
        case .about:
            AboutView()
        case let .webview(url):
            WebViewWrapper(url: url)
        default:
            EmptyView()
        }
    }
}
