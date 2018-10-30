//
//  FilterHeaderView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class FilterHeaderView: UITableViewHeaderFooterView, Reusable, BaseViewConfiguration {

    weak var delegate: CardListViewDelegate?
    fileprivate var selectedIndex: Int = 0

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

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(segmentControl)
    }

    internal func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(18)
            make.bottom.equalTo(self).offset(-8)
            make.right.equalTo(self).offset(-18)
        }
    }

    internal func configureViews() {
        self.contentView.backgroundColor = .white
        segmentControl.tintColor = ColorPalette.appTheme
    }
}
