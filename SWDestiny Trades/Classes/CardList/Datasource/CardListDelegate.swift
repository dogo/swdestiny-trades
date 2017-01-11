//
//  CardListDelegate.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol CardListViewDelegate {
    func didSelectCard(at index: IndexPath)
    func didSelectSegment(index: Int)
}

class CardListDelegate: NSObject, UITableViewDelegate {
    
    private let cardListViewDelegate: CardListViewDelegate
    private var header: FilterHeaderView?
    
    init(_ cardListDelegate: CardListViewDelegate) {
        self.cardListViewDelegate = cardListDelegate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardListViewDelegate.didSelectCard(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if header == nil {
                header = tableView.dequeueReusableHeaderFooterView(FilterHeaderView.self)
                header?.configureHeader()
                header?.delegate = cardListViewDelegate
            }
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height()
    }
}
