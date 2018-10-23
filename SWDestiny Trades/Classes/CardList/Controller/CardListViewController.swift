//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class CardListViewController: UIViewController {

    fileprivate let cardListView = CardListView()
    fileprivate let destinyService = SWDestinyServiceImpl()
    fileprivate var setDTO: SetDTO
    fileprivate lazy var navigator = CardListNavigator(self.navigationController)

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
        destinyService.retrieveSetCardList(setCode: setDTO.code.lowercased()) { result in
            switch result {
            case .success(let cardList):
                self.cardListView.cardListTableView.updateCardList(cardList)
                self.cardListView.activityIndicator.stopAnimating()
            case .failure(let error):
                self.cardListView.activityIndicator.stopAnimating()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                LoggerManager.shared.log(event: .cardsList, parameters: ["error": errorMessage])
            }
        }
        self.cardListView.cardListTableView.didSelectCard = { [unowned self] list, card in
            self.navigateToNextController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = setDTO.name
    }

    // MARK: - Navigation

    func navigateToNextController(cardList: [CardDTO], card: CardDTO) {
        self.navigator.navigate(to: .cardDetail(with: cardList, card: card))
    }
}
