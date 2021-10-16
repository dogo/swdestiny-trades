//
//  ToggleButton.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

final class ToggleButton: UIButton {
    var isActivate: Bool = false {
        didSet {
            let title = isActivate ? L10n.elite : L10n.nonElite
            let titleColor: UIColor = isActivate ? .blackWhite : .whiteBlack
            backgroundColor = isActivate ? .whiteBlack : .clear
            layer.borderColor = titleColor.cgColor
            setTitleColor(titleColor, for: .normal)
            setTitle(title, for: .normal)
        }
    }

    var buttonTouched: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.height / 2
    }

    private func initButton() {
        layer.borderWidth = 1.0
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }

    @objc
    private func buttonPressed() {
        isActivate.toggle()
        buttonTouched?(isActivate)
    }
}
