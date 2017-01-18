//
//  DeckListCell.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

class DeckListCell: UITableViewCell, Reusable, BaseViewConfiguration {
    
    var titleEditText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.text = "New Deck"
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.isUserInteractionEnabled = false
        return textField
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
    
    internal func configureCell(deck: DeckDTO) {
        //titleEditText.text = deck.name
    }
    
    override func prepareForReuse() {
        titleEditText.text = nil
    }
    
    // MARK: <BaseViewConfiguration>
    
    internal func buildViewHierarchy() {
        self.contentView.addSubview(titleEditText)
    }
    
    internal func setupConstraints() {
        titleEditText.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(12)
        }
    }
    
    internal func configureViews() {
        self.accessoryView = UIImageView(image: UIImage(named: "ic_edit"))
    }
}
