//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListViewController: UIViewController {

    private let cardListView = CardListView()
    private let destinyService = SWDestinyServiceImpl()
    private var setDTO: SetDTO
    private lazy var navigator = CardListNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(with set: SetDTO) {
        setDTO = set
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = cardListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardListView.activityIndicator.startAnimating()
        destinyService.retrieveSetCardList(setCode: setDTO.code.lowercased()) { [weak self] result in
            switch result {
            case .success(let cardList):
                self?.cardListView.cardListTableView.updateCardList(cardList)
                self?.cardListView.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.cardListView.activityIndicator.stopAnimating()
                ToastMessages.showNetworkErrorMessage()
                let printableError = error as CustomStringConvertible
                let errorMessage = printableError.description
                LoggerManager.shared.log(event: .cardsList, parameters: ["error": errorMessage])
            }
        }
        self.cardListView.cardListTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToNextController(cardList: list, card: card)
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
