//
//  SetsTableCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class SetsTableCell: UITableViewCell, Reusable, BaseViewConfiguration {

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    var expansionImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(setDTO: SetDTO) {
        titleLabel.text = setDTO.name
        expansionImageView.image = setDTO.setIcon()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        expansionImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(expansionImageView)
        self.contentView.addSubview(titleLabel)
    }

    internal func setupConstraints() {
        expansionImageView
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            .heightAnchor(equalTo: 35)
            .widthAnchor(equalTo: 35)

        titleLabel
            .centerYAnchor(equalTo: self.contentView.centerYAnchor)
            .leadingAnchor(equalTo: self.expansionImageView.trailingAnchor, constant: 12)
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
