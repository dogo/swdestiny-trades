//
//  AboutViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import SafariServices
import UIKit

final class AboutViewController: UIViewController {
    private let aboutView = AboutView()

    // MARK: - Life Cycle

    override func loadView() {
        view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutView.didTouchHTTPLink = { [weak self] url in
            let safariViewController = SFSafariViewController(url: url)
            self?.present(safariViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.about
    }
}
