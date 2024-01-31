//
//  SwdShareProviderTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 31/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SwdShareProviderTests: XCTestCase {

    func test_subjectForActivityType() {
        let subject = "Test Subject"
        let text = "Test Text"
        let shareProvider = SwdShareProvider(subject: subject, text: text)

        let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let returnedSubject = shareProvider.activityViewController(activityViewController, subjectForActivityType: nil)

        XCTAssertEqual(returnedSubject, subject, "Returned subject should match the initialized subject")
    }

    func test_itemForActivityType() {
        let subject = "Test Subject"
        let text = "Test Text"
        let shareProvider = SwdShareProvider(subject: subject, text: text)

        let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let returnedItem = shareProvider.activityViewController(activityViewController, itemForActivityType: nil) as? String

        XCTAssertEqual(returnedItem, text, "Returned item should match the initialized text")
    }
}
