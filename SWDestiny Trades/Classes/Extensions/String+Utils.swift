//
//  StringUtils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }

    func subString(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: end)

        let finalString = self.substring(from: startIndex)
        return finalString.substring(to: endIndex)
    }

    func subString(from: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        return self.substring(from: startIndex)
    }

    var length: Int {
        return self.characters.count
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind: String, linkURL: String) {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
        }
    }
}
