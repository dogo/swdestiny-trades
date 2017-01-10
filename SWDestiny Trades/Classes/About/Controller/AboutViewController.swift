//
//  AboutViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = NSLocalizedString("ABOUT", comment: "")
    }
}
