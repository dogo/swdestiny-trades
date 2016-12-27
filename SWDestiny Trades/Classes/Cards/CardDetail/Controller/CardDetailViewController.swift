//
//  CardDetailViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import Kingfisher

class CardDetailViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    public var cardDTO: CardDTO!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = cardDTO.name

        let url = URL(string: cardDTO.imageUrl)
        cardImageView.kf.indicatorType = .activity
        cardImageView.kf.setImage(with: url)
    }
}
