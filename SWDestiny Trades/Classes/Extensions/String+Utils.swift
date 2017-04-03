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
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func subString(start: Int, end: Int) -> String {
        let startIndex = index(self.startIndex, offsetBy: start)
        let endIndex = index(startIndex, offsetBy: end)

        let finalString = self[startIndex...]
        return String(finalString[..<endIndex])
    }

    func subString(from: Int) -> String {
        let startIndex = index(self.startIndex, offsetBy: from)
        return String(self[startIndex...])
    }

    var length: Int {
        return count
    }

    func removeHTMLTag() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

public extension NSMutableAttributedString {
    func setAsLink(textToFind: String, linkURL: String) {
        let foundRange = mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            addAttribute(.link, value: linkURL, range: foundRange)
        }
    }
}
