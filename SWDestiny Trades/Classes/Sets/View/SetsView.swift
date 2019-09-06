//
//  SetsView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsView: UIView, BaseViewConfiguration {

    let setsTableView: SetsTableView = {
        let view = SetsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let pullToRefresh = UIRefreshControl()

    var textColor: UIColor = .black

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginRefreshing() {
        pullToRefresh.beginRefreshing()
    }

    func endRefreshControl() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = L10n.lastUpdate(formatter.string(from: Date()))
        let attrsDictionary = [NSAttributedString.Key.foregroundColor: textColor]
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
        self.pullToRefresh.attributedTitle = attributedTitle
        self.pullToRefresh.endRefreshing()
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(setsTableView)
        setsTableView.addSubview(activityIndicator)
        setsTableView.refreshControl = pullToRefresh
    }

    internal func setupConstraints() {
        setsTableView
            .topAnchor(equalTo: self.topAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.bottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)

        activityIndicator
            .centerXAnchor(equalTo: self.centerXAnchor)
            .centerYAnchor(equalTo: self.centerYAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
        if #available(iOS 11, *) {
            textColor = .white
        }
        self.pullToRefresh.tintColor = textColor
    }
}
