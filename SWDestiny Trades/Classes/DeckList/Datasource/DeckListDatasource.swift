//
//  DeckListDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

class DeckListDatasource: NSObject, UITableViewDataSource {
    
    fileprivate var tableView: UITableView?
    fileprivate var deckList: [DeckDTO] = []
    
    required init(tableView: UITableView, delegate: UITableViewDelegate) {
        super.init()
        self.tableView = tableView
        tableView.register(cellType: DeckListCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = delegate
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DeckListCell.self)
        cell.configureCell(deck: getDeck(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckList.count
    }
    
    private func remove(at indexPath: IndexPath) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(deckList[indexPath.row])
            deckList.remove(at: indexPath.row)
        }
    }
    
    public func getDeck(at index: IndexPath) -> DeckDTO {
        return deckList[index.row]
    }
    
    public func updateTableViewData(list: [DeckDTO]) {
        deckList = list
        tableView?.reloadData()
    }
    
    public func insert(deck: DeckDTO) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(deck)
            deckList.append(deck)
            tableView?.reloadData()
        }
    }
    
    public func toggleDeckEdit(with deck: DeckDTO) {
        
    }
}

class DeckList: NSObject, UITableViewDelegate {
    
    weak var delegate: SearchDelegate?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        delegate?.didSelectAccessory?(at: indexPath)
    }
}
