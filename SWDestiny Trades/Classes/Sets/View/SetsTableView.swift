//
//  SetsTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsTableView: UITableView, SetsListViewDelegate {
    
    var didSelectSet: ((SetDTO) -> Void)?
    
    fileprivate var tableViewDatasource: SetsListDatasource?
    fileprivate var tableViewDelegate: SetsListDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDelegate = SetsListDelegate(self)
        tableViewDatasource = SetsListDatasource(tableView: self, delegate: tableViewDelegate!)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let path = indexPathForSelectedRow {
            deselectRow(at: path, animated: true)
        }
    }
        
    func updateSetList(_ sets: [SetDTO]) {
        tableViewDatasource?.sortAndSplitTableData(setList: sets)
    }
    
    // Mark: <SetsListViewDelegate>
    
    internal func didSelectSet(at index: IndexPath) {
        if let set = tableViewDatasource?.getSet(at: index) {
            didSelectSet?(set)
        }
    }
}
