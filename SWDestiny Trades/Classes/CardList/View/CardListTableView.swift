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
        alphabeticalDatasource = AlphabeticalListDatasource(tableView: self, delegate: tableViewDelegate!)
        numberDatasource = NumberListDatasource(tableView: self/*, delegate: tableViewDelegate!*/)
        colorDatasource = ColorListDatasource(tableView: self/*, delegate: tableViewDelegate!*/)
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
//        if let card = tableViewDatasource?.getCard(at: index) {
//            didSelectCard?(card)
//        }
    }
    
    // MARK: <FilterHeaderViewDelegate>
    
    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            alphabeticalDatasource?.sortAlphabetically()
        case 1:
            colorDatasource?.sortByColor()
        case 2:
            numberDatasource?.sortByCardNumber()
        default:
            break
        }
    }
}
