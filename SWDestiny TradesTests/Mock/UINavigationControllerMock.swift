//
//  UINavigationControllerMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 20/04/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class UINavigationControllerMock: UINavigationController {

    private(set) var dismissWasCalled = false
    private(set) var popViewControllerWaCalled = false
    private(set) var popToViewControllerWasCalled = false
    private(set) var popToRootViewControllerWasCalled = false

    private(set) var currentPushedViewController: UIViewController?
    private(set) var currentPresentedViewController: UIViewController?

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissWasCalled = true
        completion?()
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerWaCalled = true
        return super.popViewController(animated: false)
    }

    override func popToViewController(_ viewController: UIViewController,
                                      animated: Bool) -> [UIViewController]? {
        popToViewControllerWasCalled = true
        return super.popToViewController(viewController, animated: false)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        popToRootViewControllerWasCalled = true
        return super.popToRootViewController(animated: false)
    }

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
