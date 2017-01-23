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
    fileprivate var swdSets: [String : [SetDTO]] = [ : ]
    fileprivate var sectionLetters: [String] = []

    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: SetsTableCell.self)
        self.tableView?.sectionIndexColor = ColorPalette.appTheme
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

    public func sortAndSplitTableData(setList: [SetDTO]) {
        swdSets = Sort.splitSetsByAlphabetically(setList: setList).source
        sectionLetters = Sort.splitSetsByAlphabetically(setList: setList).firstLetters
        tableView?.reloadData()
    }
}

class SetsList: NSObject, UITableViewDelegate {

    weak var delegate: BaseDelegate?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
