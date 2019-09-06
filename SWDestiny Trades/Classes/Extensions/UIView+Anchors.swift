//
//  UIView+Anchors.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

extension UIView {

    @discardableResult
    public func topAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                          constant: CGFloat = 0,
                          priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func topAnchor(greaterThan anchor: NSLayoutYAxisAnchor,
                          constant: CGFloat = 0,
                          priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func topAnchor(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                          constant: CGFloat = 0,
                          priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func bottomAnchor(greaterThan anchor: NSLayoutYAxisAnchor,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func bottomAnchor(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                              constant: CGFloat = 0,
                              priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    public func leadingAnchor(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                              constant: CGFloat = 0,
                              priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func leadingAnchor(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                              constant: CGFloat = 0,
                              priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                               constant: CGFloat = 0,
                               priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func trailingAnchor(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                               constant: CGFloat = 0,
                               priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func trailingAnchor(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                               constant: CGFloat = 0,
                               priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func heightAnchor(equalTo height: CGFloat,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func heightAnchor(greaterThanOrEqualToConstant height: CGFloat,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func heightAnchor(lessThanOrEqualToConstant height: CGFloat,
                             priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func heightAnchor(equalTo layoutDimension: NSLayoutDimension, multiplier: CGFloat = 1.0) -> Self {
        let constraint = heightAnchor.constraint(equalTo: layoutDimension, multiplier: multiplier)
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func widthAnchor(equalTo width: CGFloat,
                            priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func widthAnchor(greaterThanOrEqualToConstant width: CGFloat,
                            priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func widthAnchor(lessThanOrEqualToConstant width: CGFloat,
                            priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func widthAnchor(equalTo layoutDimension: NSLayoutDimension, multiplier: CGFloat = 1.0) -> Self {
        let constraint = widthAnchor.constraint(equalTo: layoutDimension, multiplier: multiplier)
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func centerXAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                              constant: CGFloat = 0,
                              priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    public func centerYAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                              constant: CGFloat = 0,
                              priority: UILayoutPriority = UILayoutPriority.required) -> Self {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
}

extension UIView {

    @discardableResult
    public func inset(to view: UIView, withInset inset: UIEdgeInsets? = nil) -> Self {
        return self
            .topAnchor(equalTo: view.topAnchor, constant: inset?.top ?? 0)
            .bottomAnchor(equalTo: view.bottomAnchor, constant: -(inset?.bottom ?? 0))
            .leadingAnchor(equalTo: view.leadingAnchor, constant: inset?.left ?? 0)
            .trailingAnchor(equalTo: view.trailingAnchor, constant: -(inset?.right ?? 0))
    }

    @discardableResult
    public func aspectRadio(constant: CGFloat) -> Self {
        let constraint = widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: constant)
        constraint.priority = .required
        constraint.isActive = true
        return self
    }
}
