//
//  PeopleListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListTableView: UITableView, PeopleListViewDelegate {
    
    var didSelectPerson: ((PersonDTO) -> Void)?
    
    fileprivate var tableViewDatasource: PeopleListDatasource?
    fileprivate var tableViewDelegate: PeopleListDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDelegate = PeopleListDelegate(self)
        tableViewDatasource = PeopleListDatasource(tableView: self, delegate: tableViewDelegate!)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func updatePeopleList(_ peopleList: [PersonDTO]) {
        tableViewDatasource?.insert(personArray: peopleList)
    }
    
    func insert(_ people: PersonDTO) {
        tableViewDatasource?.insert(person: people)
    }
    
    func toggleTableViewEditable(editable: Bool) {
        self.setEditing(!editable, animated: true)
    }
    
    // MARK: <PeopleListViewDelegate>
    
    internal func didSelectPerson(at index: IndexPath) {
        if let person = tableViewDatasource?.getPerson(at: index) {
            didSelectPerson?(person)
        }
    }
}
