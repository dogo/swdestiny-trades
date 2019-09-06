//
//  AddToDeckHeaderView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/2017.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class AddToDeckHeaderView: UITableViewHeaderFooterView, Reusable, BaseViewConfiguration {

    weak var delegate: SearchDelegate?

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(frame: .zero)
        segment.translatesAutoresizingMaskIntoConstraints = false
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
        segmentControl.insertSegment(withTitle: L10n.allCards, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: L10n.myCollection, at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        segmentControl.removeAllSegments()
    }

    @objc
    func valueChanged(_ sender: UISegmentedControl) {
        self.delegate?.didSelectSegment?(index: sender.selectedSegmentIndex)
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(segmentControl)
    }

    internal func setupConstraints() {
        segmentControl
            .topAnchor(equalTo: self.topAnchor, constant: 8)
            .leadingAnchor(equalTo: self.leadingAnchor, constant: 18)
            .bottomAnchor(equalTo: self.bottomAnchor, constant: -8)
            .trailingAnchor(equalTo: self.trailingAnchor, constant: -18)
    }

    internal func configureViews() {
        self.contentView.backgroundColor = .white
        segmentControl.tintColor = ColorPalette.appTheme
    }
}
