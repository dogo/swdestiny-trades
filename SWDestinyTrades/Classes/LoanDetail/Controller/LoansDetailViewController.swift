//
//  LoansDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class LoansDetailViewController: UIViewController {

    private let loanDetailView: LoanDetailViewType

    var presenter: LoansDetailPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: LoanDetailViewType) {
        loanDetailView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loanDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.loadDataFromRealm()

        loanDetailView.didSelectCard = { [weak self] card, destination in
            self?.presenter?.navigateToCardDetail(with: card, destination: destination)
        }

        loanDetailView.didSelectAddItem = { [weak self] type in
            self?.presenter?.navigateToAddCard(type: type)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()
    }
}

extension LoansDetailViewController: LoansDetailViewControllerProtocol {

    func updateTableViewData(person: PersonDTO) {
        loanDetailView.updateTableViewData(person: person)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}
