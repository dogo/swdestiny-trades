//
//  CollapsibleTableViewHeader.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/06/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

protocol CollapsibleTableViewHeaderDelegate: class {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView, Reusable, BaseViewConfiguration {

    weak var delegate: CollapsibleTableViewHeaderDelegate?
    var section = 0

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    fileprivate var arrowLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ">"
        return label
    }()

    static func height() -> CGFloat {
        return 44
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }

    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation
        arrowLabel.rotate(toValue: collapsed ? 0.0 : CGFloat(Double.pi / 2))
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)
    }

    internal func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(12)
        }

        arrowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-12)
        }
    }

    internal func configureViews() {
        contentView.backgroundColor = ColorPalette.lightGray
    }
}
