//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

class CardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView?
    var swdCards: [Character : [CardDTO]] = [ : ]
    var sectionLetters: [Character] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        CardsAPIClient.retrieveCardList(successBlock: { (cardsArray: Array<CardDTO>) in
            self.getTableData(cardList: cardsArray)
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: path, animated: animated)
        }
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCard = swdCards[sectionLetters[indexPath.section]]?[indexPath.row]
        performSegue(withIdentifier: "CardDetailsSegue", sender: selectedCard)
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.cellIdentifier(), for: indexPath) as? CardCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(cardDTO: (swdCards[sectionLetters[indexPath.section]]?[indexPath.row])!)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionLetters[section])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLetters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swdCards[sectionLetters[section]]!.count
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardDetailsSegue" {
            if let nextViewController = segue.destination as? CardDetailViewController {
                nextViewController.cardDTO = sender as? CardDTO
            }
        }
    }

    // MARK: - Split and Sort UITableView source

    func createTableData(cardList: [CardDTO]) -> (firstLetters: [Character], source: [Character : [CardDTO]]) {

        // Build Character Set
        var letters = Set<Character>()

        func getFirstLetter(cardDTO: CardDTO) -> Character {
            return cardDTO.name[cardDTO.name.startIndex]
        }

        cardList.forEach {_ = letters.insert(getFirstLetter(cardDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [Character: [CardDTO]]()

        for symbol in letters {

            var cardsDTO = [CardDTO]()

            for card in cardList {
                if symbol == getFirstLetter(cardDTO: card) {
                    cardsDTO.append(card)
                }
            }
            tableViewSource[symbol] = cardsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    func getTableData(cardList: [CardDTO]) {
        swdCards = createTableData(cardList: cardList).source
        sectionLetters = createTableData(cardList: cardList).firstLetters
    }
}
