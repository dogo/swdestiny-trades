//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAnalytics

class CardListViewController: UIViewController {

    fileprivate let cardListView = CardListView()
    fileprivate var setDTO: SetDTO

    // MARK: - Life Cycle

    init(with set: SetDTO) {
        setDTO = set
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = cardListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardListView.activityIndicator.startAnimating()
        SWDestinyAPI.retrieveSetCardList(setCode: setDTO.code.lowercased(), successBlock: { (cardsArray: [CardDTO]) in
            self.cardListView.cardListTableView.updateCardList(cardsArray)
            self.cardListView.activityIndicator.stopAnimating()
        }) { (error: DataResponse<Any>) in
            self.cardListView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            Analytics.logEvent("retrieveSetCardList", parameters: ["error": failureReason as String])
        }

        self.cardListView.cardListTableView.didSelectCard = { [unowned self] list, card in
            self.navigateToNextController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = setDTO.name
    }

    // MARK: Navigation

    func navigateToNextController(cardList: [CardDTO], card: CardDTO) {
        let nextController = CardDetailViewController(cardList: cardList, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
