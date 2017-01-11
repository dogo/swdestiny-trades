//
//  ColorListDatasource.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

class ColorListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate var tableView: UITableView?
    fileprivate var colorCards: [String : [CardDTO]] = [ : ]
    fileprivate var sections: [String] = []

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: CardCell.self)
        tableView.register(headerFooterViewType: FilterHeaderView.self)
        self.tableView?.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.tableView?.sectionIndexBackgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CardCell.self)
        if let card = getCard(at: indexPath) {
            cell.configureCell(card: card, useIndex: true)
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
        return colorCards[sections[section]]!.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    public func getCard(at index: IndexPath) -> CardDTO? {
        return (colorCards[sections[index.section]]?[index.row])
    }

    //Mark: Sort options  
    
    public func sortByColor(cardList: [CardDTO]) {
        colorCards = Sort.splitDataByColor(cardList: cardList).source
        sections = Sort.splitDataByColor(cardList: cardList).sections
        insertHeaderToDataSource()
        tableView?.reloadData()
    }
        
    fileprivate func insertHeaderToDataSource() {
        colorCards[" "] = [CardDTO]()
        sections.insert(" ", at: 0)
    }
}
