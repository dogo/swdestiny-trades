//
//  UserCollectionViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol UserCollectionViewControllerProtocol: AnyObject {
    func setNavigationTitle(_ title: String)
    func updateTableViewData(collection: UserCollectionDTO)
    func sort(_ type: UserCollectionPresenter.SortType)
    func getCardList() -> [CardDTO]?
    func presentViewController(_ controller: UIViewController, animated: Bool)
}
