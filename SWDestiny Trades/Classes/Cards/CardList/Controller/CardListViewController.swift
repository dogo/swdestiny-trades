//
//  CardListViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class CardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    var swdSets: [String] = ["Awakenings"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")        
    }

    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetsTableCell", for: indexPath) as? UITableViewCell else {
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

