//
//  SetsListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsListDatasource: NSObject, UITableViewDataSource {

    private var tableView: UITableView?
    private var swdSets: [String: [SetDTO]] = [:]
    private var sections: [String] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: SetsTableCell.self)
        self.tableView?.sectionIndexColor = ColorPalette.appTheme
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SetsTableCell.self)
        if let set = getSet(at: indexPath) {
            cell.configureCell(setDTO: set)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sections[section])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = swdSets[sections[section]] else {
            return 0
        }
        return rows.count
    }

    func getSet(at index: IndexPath) -> SetDTO? {
        return swdSets[sections[index.section]]?[index.row]
    }

    func sortAndSplitTableData(setList: [SetDTO]) {
        sections = SectionsBuilder.alphabetically(setList: setList)
        swdSets = Split.setsByAlphabetically(setList: setList, sections: sections)
        tableView?.reloadData()
    }
}
