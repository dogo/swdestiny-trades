//
//  NewPersonViewControllerProtocol.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 27/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol NewPersonViewControllerProtocol: AnyObject {

    func setNavigationTitle(_ title: String)
    func retriveUserInput() -> (name: String, lastName: String)
    func closeViewController()
}
