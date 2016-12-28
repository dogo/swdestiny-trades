//
//  SetsListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class SetsListDatasource: NSObject, UITableViewDataSource {

    private var swdSets: [Character : [SetDTO]] = [ : ]
    private var sectionLetters: [Character] = []

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetsTableCell.cellIdentifier(), for: indexPath) as? SetsTableCell else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        cell.configureCell(setDTO: getSWDSetAt(index: indexPath)!)
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

    public func getSWDSetAt(index: IndexPath) -> SetDTO? {
        return (swdSets[sectionLetters[index.section]]?[index.row])
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
    }
}

class SetsListDelegate: NSObject, UITableViewDelegate {

    private let delegate: SetsListViewDelegate

    init(_ delegate: SetsListViewDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectSet(at: indexPath)
    }
}
