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

    var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(frame: .zero)
        return segment
    }()

    static func height() -> CGFloat {
        return 45
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBaseView()

        segmentControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

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
