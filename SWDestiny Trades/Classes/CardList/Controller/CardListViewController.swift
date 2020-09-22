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
        self.destinyService = service
        self.database = database
        self.setDTO = set
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
            self?.cardListView.activityIndicator.stopAnimating()
            switch result {
            case .success(let cardList):
                self?.cardListView.cardListTableView.updateCardList(cardList)
            case .failure(let error):
                ToastMessages.showNetworkErrorMessage()
                LoggerManager.shared.log(event: .cardsList, parameters: ["error": error.localizedDescription])
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
        self.navigator.navigate(to: .cardDetail(database: self.database, with: cardList, card: card))
    }
}
