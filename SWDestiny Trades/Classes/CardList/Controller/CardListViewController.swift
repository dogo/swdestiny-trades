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

            self.numberSource = self.sortByNumber(cardsArray: cardsArray)
            self.colorSource = self.sortByColor(cardsArray: cardsArray)
            self.alphabeticallSource = self.sortAlphabetically(cardsArray: cardsArray)
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

        self.navigationItem.title = setDTO?.name
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

    // MARK: Sort Helper

    private func sortByNumber(cardsArray: [CardDTO]) -> [CardDTO] {
        let source = cardsArray.sorted {
            $0.code < $1.code
        }
        return source
    }

    private func sortAlphabetically(cardsArray: [CardDTO]) -> [CardDTO] {
        let source = cardsArray.sorted {
            $0.name < $1.name
        }
        return source
    }

    private func sortByColor(cardsArray: [CardDTO]) -> [CardDTO] {
        var colors = Set<String>()
        var source = [CardDTO]()

        func getType(cardDTO: CardDTO) -> String {
            return cardDTO.factionCode
        }

        cardsArray.forEach {_ = colors.insert(getType(cardDTO: $0)) }

        for symbol in colors {
            for card in cardsArray {
                if symbol == card.factionCode {
                    source.append(card)
                }
            }
        }
        return sortAlphabetically(cardsArray: source)
    }
}
