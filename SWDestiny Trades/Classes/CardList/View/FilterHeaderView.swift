//
//  FilterHeaderView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class FilterHeaderView: UITableViewHeaderFooterView, Reusable {

    weak var delegate: CardListViewDelegate?
    private var selectedIndex: Int = 0

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(frame: .zero)
        segment.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return segment
    }()

    static func height() -> CGFloat {
        return 45
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureHeader() {
        segmentControl.insertSegment(withTitle: L10n.aToZ, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: L10n.color, at: 1, animated: false)
        //segmentControl.insertSegment(withTitle: "Price", at: 2, animated: false)
        segmentControl.insertSegment(withTitle: L10n.cardNumber, at: 2, animated: false)
        segmentControl.selectedSegmentIndex = selectedIndex
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        segmentControl.removeAllSegments()
    }

    @objc
    func valueChanged(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        self.delegate?.didSelectSegment(index: selectedIndex)
    }
}

extension FilterHeaderView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.addSubview(segmentControl)
    }

    internal func setupConstraints() {
        segmentControl.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.topAnchor, constant: 8)
            view.leadingAnchor(equalTo: self.leadingAnchor, constant: 18)
            view.bottomAnchor(equalTo: self.bottomAnchor, constant: -8)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -18)
        }
    }

    internal func configureViews() {
        self.contentView.backgroundColor = .blackWhite
        segmentControl.tintColor = ColorPalette.appTheme
    }
}
