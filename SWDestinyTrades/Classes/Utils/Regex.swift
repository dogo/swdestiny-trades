//
//  Regex.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 19/08/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import Foundation

struct Regex {

    let pattern: String
    let options: NSRegularExpression.Options

    private var matcher: NSRegularExpression {
        return try! NSRegularExpression(pattern: pattern, options: options) // swiftlint:disable:this force_try
    }

    init(pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }

    func match(_ string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        return matcher.numberOfMatches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count)) != 0
    }
}

protocol RegularExpressionMatchable {
    func match(_ regex: Regex) -> Bool
}

extension String: RegularExpressionMatchable {

    func match(_ regex: Regex) -> Bool {
        return regex.match(self)
    }
}

func ~= <T: RegularExpressionMatchable>(pattern: Regex, matchable: T) -> Bool {
    return matchable.match(pattern)
}
