//
//  LoansDetailViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol LoansDetailViewControllerProtocol: AnyObject {
    func updateTableViewData(person: PersonDTO)
    func setNavigationTitle(_ title: String)
}
