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
    private let database: DatabaseProtocol?
    private let destinyService: SWDestinyServiceProtocol
    private var setDTO: SetDTO
    private lazy var navigator = CardListNavigator(self.navigationController)

    // MARK: - Life Cycle

    init(service: SWDestinyServiceProtocol = SWDestinyService(), database: DatabaseProtocol?, with set: SetDTO) {
        destinyService = service
        self.database = database
        setDTO = set
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = cardListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardListView.activityIndicator.startAnimating()
        destinyService.retrieveSetCardList(setCode: setDTO.code.lowercased()) { [weak self] result in
            self?.cardListView.activityIndicator.stopAnimating()
            switch result {
            case let .success(cardList):
                self?.cardListView.cardListTableView.updateCardList(cardList)
            case let .failure(error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .cardsList, parameters: ["error": error.localizedDescription])
            }
        }
        cardListView.cardListTableView.didSelectCard = { [weak self] list, card in
            self?.navigateToNextController(cardList: list, card: card)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = setDTO.name
    }

    // MARK: - Navigation

    func navigateToNextController(cardList: [CardDTO], card: CardDTO) {
        navigator.navigate(to: .cardDetail(database: database, with: cardList, card: card))
    }
}
