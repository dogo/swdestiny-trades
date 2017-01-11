//
//  CardListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListTableView: UITableView, CardListViewDelegate {

    var didSelectCard: ((CardDTO) -> Void)?

    fileprivate var alphabeticalDatasource: AlphabeticalListDatasource?
    fileprivate var colorDatasource: ColorListDatasource?
    fileprivate var numberDatasource: NumberListDatasource?
    fileprivate var tableViewDelegate: CardListDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        tableViewDelegate = CardListDelegate(self)
        alphabeticalDatasource = AlphabeticalListDatasource(tableView: self)
        colorDatasource = ColorListDatasource(tableView: self)
        numberDatasource = NumberListDatasource(tableView: self)
        
        //Initial datasource and delegate
        self.dataSource = alphabeticalDatasource
        self.delegate = tableViewDelegate
        
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCardList(_ cards: [CardDTO]) {
        alphabeticalDatasource?.sortAlphabetically(cardList: cards)
        colorDatasource?.sortByColor(cardList: cards)
        numberDatasource?.sortByCardNumber(cardList: cards)
    }

    // MARK: <CardListViewDelegate>

    internal func didSelectCard(at index: IndexPath) {
        if let s = self.dataSource?.isKind(of: AlphabeticalListDatasource.self) {
            if let card = alphabeticalDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        } else if let s2 = self.dataSource?.isKind(of: ColorListDatasource.self) {
            if let card = colorDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        } else if let s1 = self.dataSource?.isKind(of: NumberListDatasource.self) {
            if let card = numberDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        }
    }
    
    // MARK: <FilterHeaderViewDelegate>
    
    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            self.dataSource = alphabeticalDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        case 1:
            self.dataSource = colorDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        case 2:
            self.dataSource = numberDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        default:
            break
        }
    }
}
