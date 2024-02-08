//
//  SetsTableCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

final class SetsTableCell: UITableViewCell, Identifiable {

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let expansionImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
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

    func configureCell(setDTO: SetDTO) {
        titleLabel.text = setDTO.name
        expansionImageView.image = setDTO.icon.withRenderingMode(.alwaysTemplate)
        expansionImageView.tintColor = .whiteBlack
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        expansionImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }
}

extension SetsTableCell: BaseViewConfiguration {

    func buildViewHierarchy() {
        contentView.addSubview(expansionImageView)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        expansionImageView.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.contentView.leadingAnchor, constant: 12)
            view.heightAnchor(equalToConstant: 35)
            view.widthAnchor(equalToConstant: 35)
        }

        titleLabel.layout.applyConstraint { view in
            view.centerYAnchor(equalTo: self.contentView.centerYAnchor)
            view.leadingAnchor(equalTo: self.expansionImageView.trailingAnchor, constant: 12)
        }
    }

    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}
