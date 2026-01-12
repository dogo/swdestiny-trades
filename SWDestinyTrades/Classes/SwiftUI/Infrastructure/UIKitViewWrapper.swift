//
//  UIKitViewWrapper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

struct UIKitViewWrapper<T: UIView>: UIViewRepresentable {

    let view: T

    let configure: (T) -> Void

    let onUpdate: ((T, Context) -> Void)?

    let onError: ((Error) -> Void)?

    init(view: T,
         configure: @escaping (T) -> Void = { _ in },
         onUpdate: ((T, Context) -> Void)? = nil,
         onError: ((Error) -> Void)? = nil) {
        self.view = view
        self.configure = configure
        self.onUpdate = onUpdate
        self.onError = onError
    }

    func makeUIView(context: Context) -> T {
        {
            configure(view)
            return view
        }()
    }

    func updateUIView(_ uiView: T, context: Context) {
        if let onUpdate {
            onUpdate(uiView, context)
        } else {
            configure(uiView)
        }
    }
}

struct UIKitViewControllerWrapper<T: UIViewController>: UIViewControllerRepresentable {

    let viewController: T

    let configure: (T) -> Void

    let onUpdate: ((T, Context) -> Void)?

    let onError: ((Error) -> Void)?

    init(viewController: T,
         configure: @escaping (T) -> Void = { _ in },
         onUpdate: ((T, Context) -> Void)? = nil,
         onError: ((Error) -> Void)? = nil) {
        self.viewController = viewController
        self.configure = configure
        self.onUpdate = onUpdate
        self.onError = onError
    }

    func makeUIViewController(context: Context) -> T {
        {
            configure(viewController)
            return viewController
        }()
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {
        if let onUpdate {
            onUpdate(uiViewController, context)
        } else {
            configure(uiViewController)
        }
    }
}

extension UIKitViewWrapper {

    static func tableView(
        configure: @escaping (UITableView) -> Void = { _ in },
        onUpdate: ((UITableView, Context) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> UIKitViewWrapper<UITableView> where T == UITableView {
        UIKitViewWrapper(
            view: UITableView(),
            configure: configure,
            onUpdate: onUpdate,
            onError: onError
        )
    }

    static func collectionView(
        layout: UICollectionViewLayout,
        configure: @escaping (UICollectionView) -> Void = { _ in },
        onUpdate: ((UICollectionView, Context) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> UIKitViewWrapper<UICollectionView> where T == UICollectionView {
        UIKitViewWrapper(
            view: UICollectionView(frame: .zero, collectionViewLayout: layout),
            configure: configure,
            onUpdate: onUpdate,
            onError: onError
        )
    }
}

enum UIKitIntegrationError: Error, LocalizedError {
    case viewCreationFailed(String)
    case configurationFailed(String)
    case updateFailed(String)

    var errorDescription: String? {
        switch self {
        case let .viewCreationFailed(message):
            return "Failed to create UIKit view: \(message)"
        case let .configurationFailed(message):
            return "Failed to configure UIKit view: \(message)"
        case let .updateFailed(message):
            return "Failed to update UIKit view: \(message)"
        }
    }
}
