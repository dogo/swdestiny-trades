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
    var sectionLetters: [Character] = []
    var swdSets: [Character : [SetDTO]] = [ : ]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        SetsAPIClient.retrieveSetList(successBlock: { (setsArray: Array<SetDTO>) in
            self.getTableData(setList: setsArray)
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
        let selectedSet = swdSets[sectionLetters[indexPath.section]]?[indexPath.row]
        self.performSegue(withIdentifier: "ShowSetSegue", sender: selectedSet)
    }

    // MARK: - <UITableViewDataSource>

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetsTableCell.cellIdentifier(), for: indexPath) as? SetsTableCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(setDTO: (swdSets[sectionLetters[indexPath.section]]?[indexPath.row])!)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionLetters[section])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLetters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swdSets[sectionLetters[section]]!.count
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSetSegue" {
            if let nextViewController = segue.destination as? CardListViewController {
                nextViewController.navigationItem.title = (sender as? SetDTO)?.name
            }
        }
    }

    // MARK: - Split and Sort UITableView source  

    func createTableData(setList: [SetDTO]) -> (firstLetters: [Character], source: [Character : [SetDTO]]) {

        // Build Character Set
        var letters = Set<Character>()

        func getFirstLetter(setDTO: SetDTO) -> Character {
            return setDTO.name[setDTO.name.startIndex]
        }

        setList.forEach {_ = letters.insert(getFirstLetter(setDTO: $0)) }

        // Build tableSource array
        var tableViewSource = [Character: [SetDTO]]()

        for symbol in letters {

            var setsDTO = [SetDTO]()

            for set in setList {
                if symbol == getFirstLetter(setDTO: set) {
                    setsDTO.append(set)
                }
            }
            tableViewSource[symbol] = setsDTO.sorted {
                $0.name < $1.name
            }
        }

        let sortedSymbols = letters.sorted {
            $0 < $1
        }

        return (sortedSymbols, tableViewSource)
    }

    func getTableData(setList: [SetDTO]) {
        swdSets = createTableData(setList: setList).source
        sectionLetters = createTableData(setList: setList).firstLetters
    }
}
