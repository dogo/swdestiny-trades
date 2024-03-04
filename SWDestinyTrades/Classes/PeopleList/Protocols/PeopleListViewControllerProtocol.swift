//
//  PeopleListViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 02/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

protocol PeopleListViewControllerProtocol where Self: UIViewController {
    func updateTableViewData(_ peopleList: [PersonDTO])
    func setNavigationTitle(_ title: String)
    func toggleTableViewEditable(editable: Bool, title: String)
}
