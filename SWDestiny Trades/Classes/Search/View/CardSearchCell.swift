//
//  CardSearchCell.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class CardSearchCell: UITableViewCell, Reusable, BaseViewConfiguration {

    let baseViewCell: BaseViewCell = {
        let view = BaseViewCell(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configureCell(cardDTO: CardDTO) {
        baseViewCell.titleLabel.text = cardDTO.name
        setIconImage(card: cardDTO)
        baseViewCell.subtitleLabel.text = "\(cardDTO.setName) -- \(cardDTO.rarityName)"
        baseViewCell.accessoryLabel.text = ""//cardDTO.price
    }

    private func setIconImage(card: CardDTO) {
        let imageForRendering = UIImage(named: "ic_\(card.typeCode)")?.withRenderingMode(.alwaysTemplate)
        baseViewCell.iconImageView.image = imageForRendering
        baseViewCell.iconImageView.tintColor = card.factionColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        baseViewCell.titleLabel.text = nil
        baseViewCell.subtitleLabel.text = nil
        baseViewCell.accessoryLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // just hightlight
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.contentView.addSubview(baseViewCell)
    }

    internal func setupConstraints() {
        baseViewCell
            .topAnchor(equalTo: self.contentView.topAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)
            .bottomAnchor(equalTo: self.contentView.bottomAnchor)
    }

    internal func configureViews() {
        self.accessoryType = .disclosureIndicator
    }
}
