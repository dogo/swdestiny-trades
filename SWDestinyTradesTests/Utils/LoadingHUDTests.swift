//
//  LoadingHUDTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoadingHUDTests: XCTestCase {

    private var keyWindow: UIWindow!
    private var controlller: UIViewController!
    private var HUDProvider: HUDProviderSpy!

    override func setUp() {
        super.setUp()
        HUDProvider = HUDProviderSpy()
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
        HeadUpDisplay(provider: HUDProvider).show(.success, delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .success)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showErrorHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.error, delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .error)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showProgressHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.progress, delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .progress)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showImageHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.image(Asset.icBattlefield.image), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .image(Asset.icBattlefield.image))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showRotatingImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.rotatingImage(Asset.icBattlefield.image), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .rotatingImage(Asset.icBattlefield.image))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabeledSuccessImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.labeledSuccess(title: "Title",
                                                                  subtitle: "subtitle"),
                                                  delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledSuccess(title: "Title",
                                                                                  subtitle: "subtitle"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabeledErrorImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.labeledError(title: "Title",
                                                                subtitle: "subtitle"),
                                                  delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledError(title: "Title",
                                                                                subtitle: "subtitle"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabeledProgressImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.labeledProgress(title: "Title",
                                                                   subtitle: "subtitle"),
                                                  delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledProgress(title: "Title",
                                                                                   subtitle: "subtitle"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabeledImageImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.labeledImage(image: Asset.icBattlefield.image,
                                                                title: "Title",
                                                                subtitle: "subtitle"), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledImage(image: Asset.icBattlefield.image,
                                                                                title: "Title",
                                                                                subtitle: "subtitle"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabeledRotatingImageImagesHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.labeledRotatingImage(image: Asset.icBattlefield.image,
                                                                        title: "Title",
                                                                        subtitle: "subtitle"), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledRotatingImage(image: Asset.icBattlefield.image,
                                                                                        title: "Title",
                                                                                        subtitle: "subtitle"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showLabelHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.label("Text"), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .label("Text"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showSystemActivityHUD() {
        HeadUpDisplay(provider: HUDProvider).show(.systemActivity, delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .systemActivity)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }

    func test_showCustomViewHUD() {
        let customView = UIView()
        HeadUpDisplay(provider: HUDProvider).show(.customView(view: customView), delay: 0.0)

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .customView(view: customView))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.0)
    }
}
