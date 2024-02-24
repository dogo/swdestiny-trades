//
//  LoanDetailViewType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol LoanDetailViewType where Self: UITableView {

    var didSelectCard: ((CardDTO, AddCardType) -> Void)? { get set }
    var didSelectAddItem: ((AddCardType) -> Void)? { get set }

    func updateTableViewData(person: PersonDTO)
}
