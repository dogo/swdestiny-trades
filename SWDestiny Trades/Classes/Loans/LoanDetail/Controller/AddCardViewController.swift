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

class AddCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar!
    var isLentMe: Bool!
    var personDTO: PersonDTO!
    var searchIsActive: Bool = false
    var cardsData: [CardDTO] = []
    var filtered: [CardDTO] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Card"

        self.activityIndicator.startAnimating()
        CardsAPIClient.retrieveAllCards(successBlock: { (cardsArray: Array<CardDTO>) in
            self.cardsData = cardsArray
            self.filtered = cardsArray
            self.activityIndicator.stopAnimating()
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            self.activityIndicator.stopAnimating()
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: path, animated: animated)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        insert(at: indexPath)
        self.view.endEditing(true)
        if let path = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: path, animated: true)
        }
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardSearchCell.cellIdentifier(), for: indexPath) as? CardSearchCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(cardDTO: getCard(at: indexPath))
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsActive {
            return filtered.count
        }
        return cardsData.count
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "CardDetailsSegue", sender: getCard(at: indexPath))
    }

    // MARK: - Helpers

    private func getCard(at indexPath: IndexPath) -> CardDTO {
        return searchIsActive ? filtered[indexPath.row] : cardsData[indexPath.row]
    }

    private func insert(at indexPath: IndexPath) {
        let realm = try! Realm()
        try! realm.write {
            let card = getCard(at: indexPath)
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
        let success = MessageView.viewFromNib(layout: .CardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Added", body: card.name)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .bottom
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
    }

    // MARK: - <UISearchBarDelegate>

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.trim().isEmpty {
            searchIsActive = false
        } else {
            filtered = cardsData.filter({ (card) -> Bool in
                return card.name.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil
            })
            searchIsActive = true
        }
        tableView?.reloadData()
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardDetailsSegue" {
            if let nextViewController = segue.destination as? CardDetailViewController {
                nextViewController.cardDTO = sender as? CardDTO
            }
        }
    }
}
