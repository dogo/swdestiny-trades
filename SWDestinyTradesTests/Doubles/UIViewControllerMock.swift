//
//  UIViewControllerMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import UIKit

final class UIViewControllerMock: UIViewController {

    private(set) var hasDismissCalled = false
    private(set) var hasRemoveFromParentCalled = false
    private(set) var contentView: UIView
    private(set) var viewWillAppearCount: Int = 0
    private var presentedViewControllerValue: UIViewController?

    init(withView: UIView = UIView()) {
        contentView = withView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearCount += 1
    }

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {

        presentedViewControllerValue = viewControllerToPresent
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hasDismissCalled = true
        completion?()
    }

    override var presentedViewController: UIViewController? {
        return presentedViewControllerValue
    }

    override func removeFromParent() {
        hasRemoveFromParentCalled = true
    }
}
