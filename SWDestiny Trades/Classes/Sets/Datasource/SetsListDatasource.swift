//
//  SetsListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class SetsListDatasource: NSObject, UITableViewDataSource {

    fileprivate var tableView: UITableView?
    fileprivate var swdSets: [Character : [SetDTO]] = [ : ]
    fileprivate var sectionLetters: [Character] = []

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: SetsTableCell.self)
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SetsTableCell.self)
        cell.configureCell(setDTO: getSet(at: indexPath))
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

    public func getSet(at index: IndexPath) -> SetDTO {
        return (swdSets[sectionLetters[index.section]]?[index.row])!
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

    public func sortAndSplitTableData(setList: [SetDTO]) {
        swdSets = createTableData(setList: setList).source
        sectionLetters = createTableData(setList: setList).firstLetters
        tableView?.reloadData()
    }
}

class SetsListDelegate: NSObject, UITableViewDelegate {

    private let delegate: SetsListViewDelegate

    init(_ delegate: SetsListViewDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectSet(at: indexPath)
    }
}
