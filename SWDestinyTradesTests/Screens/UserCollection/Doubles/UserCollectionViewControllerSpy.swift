//
//  UserCollectionViewControllerSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class UserCollectionViewControllerSpy: UIViewController, UserCollectionViewControllerProtocol, UserCollectionProtocol {

    private(set) var didCallSetNavigationTitle = [String]()
    func setNavigationTitle(_ title: String) {
        didCallSetNavigationTitle.append(title)
    }

    private(set) var didCallUpdateTableViewData = [UserCollectionDTO]()
    func updateTableViewData(collection: UserCollectionDTO) {
        didCallUpdateTableViewData.append(collection)
    }

    private(set) var didCallSort = [Int]()
    func sort(_ selectedIndex: Int) {
        didCallSort.append(selectedIndex)
    }

    private(set) var didCallGetCardListCount = 0
    var cardList: [CardDTO]? = [.stub()]
    func getCardList() -> [CardDTO]? {
        didCallGetCardListCount += 1
        return cardList
    }

    private(set) var didCallPresentViewController = [(controller: UIViewController, animated: Bool)]()
    func presentViewController(_ controller: UIViewController, animated: Bool) {
        didCallPresentViewController.append((controller, animated))
    }

    private(set) var didCallStepperValueChangedValues: [(newValue: Int, card: CardDTO)] = []
    func stepperValueChanged(newValue: Int, card: CardDTO) {
        didCallStepperValueChangedValues.append((newValue, card))
    }

    private(set) var didCallRemoveValues: [Int] = []
    func remove(at index: Int) {
        didCallRemoveValues.append(index)
    }

    private(set) var didCallUpdateSetList = [SetDTO]()
    func updateSetList(_ setList: [SetDTO]) {
        didCallUpdateSetList.append(contentsOf: setList)
    }
}
