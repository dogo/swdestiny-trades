//
//  AboutViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {

    fileprivate let aboutView = AboutView()

    // MARK: - Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutView.didTouchHTTPLink = { [unowned self] url in
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(safariViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.about
    }
}
