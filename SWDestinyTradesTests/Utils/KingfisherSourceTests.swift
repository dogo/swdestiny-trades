//
//  KingfisherSourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 31/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import Kingfisher
import XCTest

@testable import SWDestinyTrades

final class KingfisherSourceTests: XCTestCase {

    func test_imageLoading() {
        let url = URL(string: "http://swdestinydb.com/bundles/cards/en/01/01001.jpg")!
        let kingfisherSource = KingfisherSource(url: url, placeholder: Asset.ic404.image, options: nil)
        let imageView = UIImageView()

        let expectation = XCTestExpectation(description: "Image loaded successfully")
        kingfisherSource.load(to: imageView) { loadedImage in
            XCTAssertNotNil(loadedImage, "Image loading failed")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_invalidURLInitialization() {
        let invalidURLString = "invalid-url"
        let kingfisherSource = KingfisherSource(urlString: invalidURLString, placeholder: Asset.ic404.image, options: nil)
        let imageView = UIImageView()

        let expectation = XCTestExpectation(description: "Image loading should fail")
        kingfisherSource?.load(to: imageView) { loadedImage in
            XCTAssertNil(loadedImage, "Image loading should fail for an invalid URL")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
