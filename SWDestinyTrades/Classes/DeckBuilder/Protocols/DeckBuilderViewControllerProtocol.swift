//
//  DeckBuilderViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 10/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol DeckBuilderViewControllerProtocol: AnyObject {

    func updateTableViewData(deck: DeckDTO)
    func getDeckList() -> [DeckBuilderDatasource.Section]?
    func presentViewController(_ controller: UIViewController, animated: Bool)
    func setNavigationTitle(_ title: String)
}
