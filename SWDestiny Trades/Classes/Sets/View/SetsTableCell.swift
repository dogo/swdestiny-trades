//
//  SetsTableCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class SetsTableCell: UITableViewCell, Reusable, BaseViewConfiguration {

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    var expansionImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        return image
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(setDTO: SetDTO) {
        titleLabel.text = setDTO.name

        if setDTO.code.lowercased() == "aw" {
            expansionImageView.image = Asset.Sets.icAwakenings.image
        } else if setDTO.code.lowercased() == "sor" {
            expansionImageView.image = Asset.Sets.icSpiritOfRebellion.image
        } else if setDTO.code.lowercased() == "eaw" {
            expansionImageView.image = Asset.Sets.icEmpireAtWar.image
        } else if setDTO.code.lowercased() == "tpg" {
            expansionImageView.image = Asset.Sets.icTwoPlayerGame.image
        } else if setDTO.code.lowercased() == "leg" {
            expansionImageView.image = Asset.Sets.icLegacies.image
        } else {
            expansionImageView.image = Asset.Sets.icNotFound.image
        }
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
        expansionImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(12)
            make.height.equalTo(35)
            make.width.equalTo(35)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(expansionImageView.snp.right).offset(12)
        }
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
