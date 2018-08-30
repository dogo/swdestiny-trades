//
//  SetsTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsTableView: UITableView {

    var didSelectSet: ((SetDTO) -> Void)?

    fileprivate var tableViewDatasource: SetsListDatasource?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        tableViewDatasource = SetsListDatasource(tableView: self)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSetList(_ sets: [SetDTO]) {
        tableViewDatasource?.sortAndSplitTableData(setList: sets)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
        if let set = tableViewDatasource?.getSet(at: index) {
            didSelectSet?(set)
        }
    }
}

extension SetsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }
}
