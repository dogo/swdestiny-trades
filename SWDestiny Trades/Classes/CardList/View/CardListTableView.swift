//
//  CardListTableView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListTableView: UITableView, CardListViewDelegate {

    fileprivate enum PresentationState {
        case color, number, alphabet
    }

    var didSelectCard: ((CardDTO) -> Void)?

    fileprivate var currentPresentationState = PresentationState.alphabet
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

        self.register(cellType: CardCell.self)
        self.register(headerFooterViewType: FilterHeaderView.self)
        self.backgroundColor = UIColor.white
        self.sectionIndexColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.sectionIndexBackgroundColor = .clear
        self.delegate = tableViewDelegate
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
        switch self.currentPresentationState {
        case .alphabet:
            if let card = alphabeticalDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        case .color:
            if let card = colorDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        case .number:
            if let card = numberDatasource?.getCard(at: index) {
                didSelectCard?(card)
            }
        }
    }

    // MARK: <FilterHeaderViewDelegate>

    internal func didSelectSegment(index: Int) {
        switch index {
        case 0:
            currentPresentationState = .alphabet
            self.dataSource = alphabeticalDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        case 1:
            currentPresentationState = .color
            self.dataSource = colorDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        case 2:
            currentPresentationState = .number
            self.dataSource = numberDatasource
            self.delegate = tableViewDelegate
            self.reloadData()
        default:
            break
        }
    }
}
