//
//  AboutViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    var presenter: AboutPresenterProtocol?
    private let aboutView: AboutViewType

    // MARK: - Life Cycle

    init(with view: AboutViewType = AboutView()) {
        aboutView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutView.didTouchHTTPLink = { [weak self] url in
            self?.presenter?.didTouchHTTPUrl(url)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.about
    }
}
