//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

protocol CardListViewDelegate {
    func didSelectCard(at index: IndexPath)
}

class CardListViewController: UIViewController {

    let cardListView = CardListView()
    var setDTO: SetDTO?

    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = cardListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = setDTO?.name
        
        cardListView.activityIndicator.startAnimating()
        CardsAPIClient.retrieveSetCardList(setCode: setDTO!.code.lowercased(), successBlock: { (cardsArray: Array<CardDTO>) in
            self.cardListView.cardListTableView.updateCardList(cardsArray)
            self.cardListView.activityIndicator.stopAnimating()
        }) { (error: DataResponse<Any>) in
            self.cardListView.activityIndicator.stopAnimating()
            print(error)
        }
        
        self.cardListView.cardListTableView.didSelectCard = { [weak self] card in
            self?.navigateToNextController(with: card)
        }
    }

    // MARK: TEMP

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
