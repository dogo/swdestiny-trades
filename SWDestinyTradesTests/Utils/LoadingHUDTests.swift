//
//  LoadingHUDTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import PKHUD
@testable import SWDestinyTrades

final class LoadingHUDTests: XCTestCase {

    private var keyWindow: UIWindow!
    private var controlller: UIViewController!

    override func setUp() {
        super.setUp()
        controlller = UIViewController()
        keyWindow = UIWindow(frame: .testDevice)
        keyWindow.showTestWindow(controller: controlller)
    }

    override func tearDown() {
        controlller = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_showSuccessHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.success, delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { error in
            XCTAssertNil(error, "HUD not shown in time")
            // XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showErrorHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.error, delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showProgressHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.progress, delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showImageHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.image(Asset.icBattlefield.image), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showRotatingImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.rotatingImage(Asset.icBattlefield.image), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabeledSuccessImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.labeledSuccess(title: "Title", subtitle: "subtitle"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { error in
            XCTAssertNil(error, "HUD not shown in time")
            // XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabeledErrorImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.labeledError(title: "Title", subtitle: "subtitle"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { error in
            XCTAssertNil(error, "HUD not shown in time")
            // XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabeledProgressImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.labeledProgress(title: "Title", subtitle: "subtitle"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabeledImageImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.labeledImage(image: Asset.icBattlefield.image,
                                      title: "Title",
                                      subtitle: "subtitle"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabeledRotatingImageImagesHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.labeledRotatingImage(image: Asset.icBattlefield.image,
                                              title: "Title",
                                              subtitle: "subtitle"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showLabelHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.label("Text"), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showSystemActivityHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        LoadingHUD.show(.systemActivity, delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }

    func test_showCustomViewHUD() {
        let expectation = expectation(description: "HUD shown successfully")

        let customView = UIView()
        LoadingHUD.show(.customView(view: customView), delay: 0.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.3) { [weak self] error in
            XCTAssertNil(error, "HUD not shown in time")
            XCTAssertTrue(self!.keyWindow.subviews.contains { $0 is ContainerView })
        }
    }
}
