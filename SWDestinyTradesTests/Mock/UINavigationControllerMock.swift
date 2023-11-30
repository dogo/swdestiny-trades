//
//  UINavigationControllerMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class UINavigationControllerMock: UINavigationController {

    override init(rootViewController: UIViewController = UIViewController()) {
        super.init(rootViewController: rootViewController)
        setViewControllers = [rootViewController]
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var currentPresentedViewController: UIViewController?
    override var presentedViewController: UIViewController? {
        return currentPresentedViewController
    }

    private(set) var visibleViewControllerCount = 0
    override var visibleViewController: UIViewController? {
        visibleViewControllerCount += 1
        return super.visibleViewController
    }

    private(set) var dismissCount = 0
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCount += 1
        completion?()
    }

    private(set) var setViewControllersCount = 0
    private(set) var setViewControllers: [UIViewController]?
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        setViewControllersCount += 1
        setViewControllers = viewControllers
        super.setViewControllers(viewControllers, animated: false)
    }

    private(set) var popViewControllerCount = 0
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCount += 1
        return super.popViewController(animated: false)
    }

    private(set) var popToViewControllerCount = 0
    override func popToViewController(_ viewController: UIViewController,
                                      animated: Bool) -> [UIViewController]? {
        popToViewControllerCount += 1
        return super.popToViewController(viewController, animated: false)
    }

    private(set) var popToRootViewControllerCount = 0
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        popToRootViewControllerCount += 1
        return super.popToRootViewController(animated: false)
    }

    private(set) var currentPushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        currentPushedViewController = viewController
        super.pushViewController(viewController, animated: false)
    }

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        currentPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: false, completion: completion)
    }
}
