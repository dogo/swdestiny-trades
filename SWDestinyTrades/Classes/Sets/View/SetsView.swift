//
//  SetsView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsView: UIView, SetsListViewType {

    var didSelectSet: ((SetDTO) -> Void)?

    private let setsTableView = SetsTableView()

    let pullToRefresh = UIRefreshControl()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .whiteBlack
        return view
    }()

    private var textColor: UIColor = .black

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()

        setsTableView.didSelectSet = { [weak self] set in
            self?.didSelectSet?(set)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
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
        pullToRefresh.attributedTitle = attributedTitle
        pullToRefresh.endRefreshing()
    }

    func updateSetList(_ sets: [SetDTO]) {
        setsTableView.updateSetList(sets)
    }

    func setupPullToRefresh(target: Any, action: Selector) {
        pullToRefresh.addTarget(target, action: action, for: .valueChanged)
    }
}

extension SetsView: BaseViewConfiguration {
    func buildViewHierarchy() {
        addSubview(setsTableView)
        setsTableView.addSubview(activityIndicator)
        setsTableView.refreshControl = pullToRefresh
    }

    func setupConstraints() {
        setsTableView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.topAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.bottomAnchor(equalTo: self.bottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
        }

        activityIndicator.layout.applyConstraint { view in
            view.centerXAnchor(equalTo: self.centerXAnchor)
            view.centerYAnchor(equalTo: self.centerYAnchor)
        }
    }

    func configureViews() {
        backgroundColor = .blackWhite
        if #available(iOS 11, *) {
            textColor = .white
        }
        pullToRefresh.tintColor = textColor
    }
}
