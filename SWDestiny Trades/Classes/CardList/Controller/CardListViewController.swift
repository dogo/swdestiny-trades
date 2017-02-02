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
    fileprivate var alphabeticallSource = [CardDTO]()
    fileprivate var colorSource = [CardDTO]()
    fileprivate var numberSource = [CardDTO]()
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

            self.numberSource = Sort.cardsByNumber(cardsArray: cardsArray)
            self.colorSource = Sort.cardsByColor(cardsArray: cardsArray)
            self.alphabeticallSource = Sort.cardsAlphabetically(cardsArray: cardsArray)
        }) { (error: DataResponse<Any>) in
            self.cardListView.activityIndicator.stopAnimating()
            let failureReason = error.failureReason()
            print(failureReason)
            FIRAnalytics.logEvent(withName: "[Error] retrieveSetCardList", parameters: ["error": failureReason as NSObject])
        }

        self.cardListView.cardListTableView.didSelectCard = { [weak self] segment, card in
            self?.navigateToNextController(segment: segment, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = setDTO.name
    }

    // MARK: Navigation

    func navigateToNextController(segment: Int, card: CardDTO) {

        var currentSource: [CardDTO] {
            switch segment {
            case 0: return alphabeticallSource
            case 1: return colorSource
            case 2: return numberSource
            default:
                return alphabeticallSource
            }
        }

        let nextController = CardDetailViewController(cardList: currentSource, selected: card)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
