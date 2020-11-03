//
//  CollapsibleTableViewHeader.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/06/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate: AnyObject {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int)
}

final class CollapsibleTableViewHeader: UITableViewHeaderFooterView, Identifiable {
    weak var delegate: CollapsibleTableViewHeaderDelegate?
    var section = 0

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private var arrowLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ">"
        return label
    }()

    static func height() -> CGFloat {
        return 44
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBaseView()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }

    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation
        arrowLabel.rotate(toValue: collapsed ? 0.0 : CGFloat(Double.pi / 2))
    }
}

extension CollapsibleTableViewHeader: BaseViewConfiguration {
    internal func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)
    }

    internal func setupConstraints() {
        titleLabel.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.centerYAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor, constant: 12)
        }

        arrowLabel.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.centerYAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor, constant: -12)
        }
    }

    internal func configureViews() {
        contentView.backgroundColor = .sectionColor
    }
}
