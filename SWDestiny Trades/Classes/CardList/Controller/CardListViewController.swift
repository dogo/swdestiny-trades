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
    fileprivate var source = [CardDTO]()
    var setDTO: SetDTO?

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        SWDestinyAPI.retrieveSetCardList(setCode: setDTO!.code.lowercased(), successBlock: { (cardsArray: [CardDTO]) in
            self.cardListView.cardListTableView.updateCardList(cardsArray)
            self.cardListView.activityIndicator.stopAnimating()

            self.source = cardsArray.sorted {
                $0.name < $1.name
            }

        }) { (error: DataResponse<Any>) in
            self.cardListView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            FIRAnalytics.logEvent(withName: "[Error] retrieveSetCardList", parameters: ["error": failureReason as NSObject])
        }

        self.cardListView.cardListTableView.didSelectCard = { [weak self] card in
            self?.navigateToNextController(with: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = setDTO?.name
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController(cardList: source, selected: card!)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
