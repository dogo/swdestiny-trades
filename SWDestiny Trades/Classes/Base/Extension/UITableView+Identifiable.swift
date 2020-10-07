//
//  UITableView+Identifiable.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

public extension UITableView {

    /**
     Register a Class-Based `UITableViewCell` subclass (conforming to `Identifiable`)
     - parameter cellType: the `UITableViewCell` (`Identifiable`-conforming) subclass to register
     */
    final func register<T: UITableViewCell>(cellType: T.Type) where T: Identifiable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    /**
     Register a Class-Based `UITableViewHeaderFooterView` subclass (conforming to `Identifiable`)
     - parameter headerFooterViewType: the `UITableViewHeaderFooterView` (`Identifiable`-confirming) subclass to register
     - seealso: `register(_:,forHeaderFooterViewReuseIdentifier:)`
     */
    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
      where T: Identifiable {
        self.register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }

    /**
     Returns a Identifiable `UITableViewCell` object for the class inferred by the return-type
     - parameter indexPath: The index path specifying the location of the cell.
     - parameter cellType: The cell class to dequeue
     - returns: A `Identifiable`, `UITableViewCell` instance
     - note: The `cellType` parameter can generally be omitted and infered by the return type,
     except when your type is in a variable and cannot be determined at compile time.
     */
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Identifiable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }

    /**
     Returns a Identifiable `UITableViewHeaderFooterView` object for the class inferred by the return-type
     - parameter viewType: The view class to dequeue
     - returns: A `Identifiable`, `UITableViewHeaderFooterView` instance
     - note: The `viewType` parameter can generally be omitted and infered by the return type,
     except when your type is in a variable and cannot be determined at compile time.
     - seealso: `dequeueReusableHeaderFooterView(withIdentifier:)`
     */
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T?
      where T: Identifiable {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
          fatalError(
            "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
              + "matching type \(viewType.self). "
              + "Check the reuseIdentifier that you registered the header/footer beforehand"
          )
        }
        return view
    }
}
