//
//  CardListDelegate.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol CardListViewDelegate: BaseDelegate {
    func didSelectSegment(index: Int)
}

class CardList: NSObject, UITableViewDelegate {

    weak var delegate: CardListViewDelegate?
    private var header: FilterHeaderView?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(index: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if header == nil {
                header = tableView.dequeueReusableHeaderFooterView(FilterHeaderView.self)
                header?.configureHeader()
                header?.delegate = delegate
            }
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height()
    }
}
