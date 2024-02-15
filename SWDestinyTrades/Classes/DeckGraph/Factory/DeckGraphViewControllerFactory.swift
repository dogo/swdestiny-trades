//
//  DeckGraphViewControllerFactory.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

final class DeckGraphViewControllerFactory: ViewControllerFactory {

    private let deckDTO: DeckDTO

    init(deck: DeckDTO) {
        deckDTO = deck
    }

    func createViewController() -> UIViewController {
        let view = DeckGraphCollectionView()
        let viewController = DeckGraphViewController(with: view)
        let presenter = DeckGraphPresenter(controller: viewController,
                                           deckDTO: deckDTO)
        viewController.presenter = presenter
        return viewController
    }
}
