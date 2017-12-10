//
//  CardListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListTableView: UITableView, CardListViewDelegate {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)?

    private var alphabeticalDatasource: AlphabeticalListDatasource?
    private var colorDatasource: ColorListDatasource?
    private var numberDatasource: NumberListDatasource?
    private let cardList = CardList()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        cardList.delegate = self
        alphabeticalDatasource = AlphabeticalListDatasource(tableView: self)
        colorDatasource = ColorListDatasource(tableView: self)
        numberDatasource = NumberListDatasource(tableView: self)

        // Initial datasource and delegate
        self.dataSource = alphabeticalDatasource

        self.register(cellType: CardCell.self)
        self.register(headerFooterViewType: FilterHeaderView.self)
        self.backgroundColor = .white
        self.sectionIndexColor = ColorPalette.appTheme
        self.sectionIndexBackgroundColor = .clear
        self.delegate = cardList
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

    internal func didSelectRowAt(index: IndexPath) {
        if let currentDatasource: CardReturnable = self.dataSource as? CardReturnable {
            if let card = currentDatasource.getCard(at: index) {
                didSelectCard?(currentDatasource.getCardList(), card)
            }
        }
    }

    // MARK: <FilterHeaderViewDelegate>

    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            self.dataSource = alphabeticalDatasource
            self.reloadData()
        case 1:
            self.dataSource = colorDatasource
            self.reloadData()
        case 2:
            self.dataSource = numberDatasource
            self.reloadData()
        default:
            break
        }
    }
}
