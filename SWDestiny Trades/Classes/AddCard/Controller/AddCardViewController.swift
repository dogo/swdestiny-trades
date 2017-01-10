//
//  AddCardViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftMessages

class AddCardViewController: UIViewController {

    fileprivate let searchView = SearchView()
    var isLentMe: Bool!
    var personDTO: PersonDTO!

    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Card"

        searchView.activityIndicator.startAnimating()
        CardsAPIClient.retrieveAllCards(successBlock: { (cardsArray: Array<CardDTO>) in
            self.searchView.activityIndicator.stopAnimating()
            self.searchView.searchTableView.updateSearchList(cardsArray)
        }) { (error: DataResponse<Any>) in
            self.searchView.activityIndicator.stopAnimating()
            print(error)
        }
        
        searchView.searchTableView.didSelectCard = { [weak self] card in
            self?.insert(card: card)
            if let path = self?.searchView.searchTableView.indexPathForSelectedRow {
                self?.searchView.searchTableView.deselectRow(at: path, animated: true)
            }
        }
        
        searchView.searchBar.doingSearch = { [weak self] query in
            self?.searchView.searchTableView.doingSearch(query)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchBar.becomeFirstResponder()
    }

//
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        navigateToNextController(with: getCard(at: indexPath))
//    }

    // MARK: - Helpers

    private func insert(card: CardDTO) {
        let realm = try! Realm()
        try! realm.write {
            if isLentMe! {
                personDTO.lentMe.append(card)
            } else {
                personDTO.borrowed.append(card)
            }
            showSuccessMessage(card: card)
            realm.add(personDTO, update: true)
            let personDataDict: [String: PersonDTO] = ["personDTO": personDTO]
            NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
        }
    }

    private func showSuccessMessage(card: CardDTO) {
        let success: MessageView
        if #available(iOS 9.0, *) {
            success = MessageView.viewFromNib(layout: .CardView)
        } else {
            success = MessageView.viewFromNib(layout: .MessageViewIOS8)
        }
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Added", body: card.name)
        success.button?.isHidden = true
        SwiftMessages.show(view: success)
    }

    // MARK: Navigation

    func navigateToNextController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
