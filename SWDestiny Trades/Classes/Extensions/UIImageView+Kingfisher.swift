//
//  UIImage+Kingfisher.swift
//  SWDestiny Trades
//
//  Created by Thiago Lioy on 20/11/16.
//  Copyright © 2016 Thiago Lioy. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
}
