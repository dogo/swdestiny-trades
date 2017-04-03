//
//  UIImage+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 19/03/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIImage {
    func tintColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        if let mask = cgImage {
            context?.clip(to: rect, mask: mask)
        }
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
