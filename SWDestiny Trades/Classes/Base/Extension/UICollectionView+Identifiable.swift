//
//  UICollectionView+Identifiable.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

public extension UICollectionView {
    /**
     Register a Class-Based `UICollectionViewCell` subclass (conforming to `Identifiable`)
     - parameter cellType: the `UICollectionViewCell` (`Identifiable`-conforming) subclass to register
     - seealso: `register(_:,forCellWithReuseIdentifier:)`
     */
    final func register<T: UICollectionViewCell>(cellType: T.Type)
        where T: Identifiable
    {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    /**
     Returns a reusable `UICollectionViewCell` object for the class inferred by the return-type
     - parameter indexPath: The index path specifying the location of the cell.
     - parameter cellType: The cell class to dequeue
     - returns: A `Identifiable`, `UICollectionViewCell` instance
     - note: The `cellType` parameter can generally be omitted and infered by the return type,
     except when your type is in a variable and cannot be determined at compile time.
     - seealso: `dequeueReusableCell(withReuseIdentifier:,for:)`
     */
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
        where T: Identifiable
    {
        let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                    + "Check the reuseIdentifier that you registered the cell beforehand"
            )
        }
        return cell
    }
}
