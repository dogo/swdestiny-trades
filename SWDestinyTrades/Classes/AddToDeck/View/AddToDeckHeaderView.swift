//
//  AddToDeckHeaderView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/2017.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddToDeckHeaderView: UITableViewHeaderFooterView, Identifiable {

    weak var delegate: SearchDelegate?

    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(frame: .zero)
        segment.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return segment
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        segmentControl.removeAllSegments()
    }

    static func height() -> CGFloat {
        return 45
    }

    func configureHeader() {
        segmentControl.insertSegment(withTitle: L10n.allCards, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: L10n.myCollection, at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
    }

    @objc
    func valueChanged(_ sender: UISegmentedControl) {
        if sender === segmentControl {
            delegate?.didSelectSegment?(index: sender.selectedSegmentIndex)
        }
    }
}

extension AddToDeckHeaderView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(segmentControl)
    }

    func setupConstraints() {
        segmentControl.layout.applyConstraint {
            $0.topAnchor(equalTo: self.topAnchor, constant: 8)
            $0.leadingAnchor(equalTo: self.leadingAnchor, constant: 18)
            $0.bottomAnchor(equalTo: self.bottomAnchor, constant: -8)
            $0.trailingAnchor(equalTo: self.trailingAnchor, constant: -18)
        }
    }

    func configureViews() {
        segmentControl.tintColor = ColorPalette.appTheme
    }
}
