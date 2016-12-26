//
//  SetsListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Alamofire

class SetsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView?
    var swdSets: [String] = ["Awakenings"]

    override func viewDidLoad() {
        super.viewDidLoad()

        SetsAPIClient.retrieveSetList(successBlock: { (array: Array<SetDTO>) in
            print(array)
        }) { (error: DataResponse<Any>) in
          print(error)
        }
    }

    // MARK: - <UITableViewDelegate>

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowSetSegue", sender: nil)
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetsTableCell", for: indexPath) as? SetsTableCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swdSets.count
    }
}
