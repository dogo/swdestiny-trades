//
//  StringUtils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

public extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
