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
    var swdCards: [CardDTO] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        CardsAPIClient.retrieveCardList(successBlock: { (cardsArray: Array<CardDTO>) in
            self.swdCards = cardsArray.sorted {
                $0.name < $1.name
            }
            self.tableView?.reloadData()
        }) { (error: DataResponse<Any>) in
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = self.tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRow(at: path, animated: animated)
        }
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.cellIdentifier(), for: indexPath) as? CardCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(cardDTO: self.swdCards[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swdCards.count
    }
}
