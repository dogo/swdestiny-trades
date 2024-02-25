//
//  LoanDetailViewSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

final class LoanDetailViewSpy: UITableView, LoanDetailViewType {

    var didSelectCard: ((CardDTO, AddCardType) -> Void)?
    var didSelectAddItem: ((AddCardType) -> Void)?

    private(set) var didCallUpdateTableViewData = [PersonDTO]()
    func updateTableViewData(person: PersonDTO) {
        didCallUpdateTableViewData.append(person)
    }
}
