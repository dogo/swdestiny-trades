//
//  SWDKingfisherSource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 01/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Kingfisher
import ImageSlideshow

/// Input Source to image using Kingfisher
public class KingfisherSource: NSObject, InputSource {
    var url: URL
    var placeholder: UIImage?

    /// Initializes a new source with a URL
    /// - parameter url: a url to be loaded
    public init(url: URL) {
        self.url = url
        super.init()
    }

    /// Initializes a new source with URL and placeholder
    /// - parameter url: a url to be loaded
    /// - parameter placeholder: a placeholder used before image is loaded
    public init(url: URL, placeholder: UIImage?) {
        self.url = url
        self.placeholder = placeholder
        super.init()
    }

    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to be loaded
    public init?(urlString: String) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            super.init()
        } else {
            return nil
        }
    }

    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to be loaded
    /// - parameter placeholder: a placeholder used before image is loaded
    public init?(urlString: String, placeholder: UIImage?) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.placeholder = placeholder
            super.init()
        } else {
            return nil
        }
    }

    @objc public func load(to imageView: UIImageView, with callback: @escaping (UIImage) -> Void) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: self.url, placeholder: self.placeholder, options: nil, progressBlock: nil) { (image, _, _, _) in
            if let image = image {
                callback(image)
            }
        }
    }
}