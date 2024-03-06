//
//  PeopleListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

protocol UpdateTableDataDelegate: AnyObject {
    func insertNew(person: PersonDTO)
}

final class PeopleListViewController: UIViewController {

    private let peopleListView: PeopleListViewType

    var presenter: PeopleListPresenterProtocol?

    // MARK: - Life Cycle

    init(with view: PeopleListViewType) {
        peopleListView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = peopleListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.setupNavigationItems { [weak self] items in
            self?.navigationItem.leftBarButtonItem = items?.first
            self?.navigationItem.rightBarButtonItem = items?.last
        }

        presenter?.loadDataFromRealm()

        peopleListView.didSelectPerson = { [weak self] person in
            self?.presenter?.navigateToLoansDetail(person: person)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.setNavigationTitle()
        peopleListView.reloadData()
    }
}

extension PeopleListViewController: PeopleListViewControllerProtocol {

    func updateTableViewData(_ peopleList: [PersonDTO]) {
        peopleListView.updateTableViewData(peopleList)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func toggleTableViewEditable(editable: Bool, title: String) {
        super.setEditing(!editable, animated: true)
        peopleListView.toggleTableViewEditable(editable: editable)
        navigationItem.leftBarButtonItem?.title = title
    }

    func insert(_ person: PersonDTO) {
        peopleListView.insert(person)
    }
}
