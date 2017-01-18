//
//  DeckListDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

class DeckListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate var tableView: UITableView?
    fileprivate var deckList: [DeckDTO] = []
    
    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: SetsTableCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SetsTableCell.self)
        //cell.configureCell(setDTO: getDeck(at: indexPath))
        cell.titleLabel.text = "getDeck(at: indexPath)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckList.count
    }
    
    public func getDeck(at index: IndexPath) -> DeckDTO {
        return deckList[index.row]
    }
    
    public func updateTableViewData(list: [DeckDTO]) {
        deckList = list
        tableView?.reloadData()
    }
}

class DeckList: NSObject, UITableViewDelegate {
    
    weak var delegate: BaseDelegate?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
