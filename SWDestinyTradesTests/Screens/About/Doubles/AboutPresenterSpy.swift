//
//  AboutPresenterSpy.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class AboutPresenterSpy: AboutPresenterProtocol {

    private(set) var didCallDidTouchHTTPUrl = [URL]()
    func didTouchHTTPUrl(_ url: URL) {
        didCallDidTouchHTTPUrl.append(url)
    }
}
