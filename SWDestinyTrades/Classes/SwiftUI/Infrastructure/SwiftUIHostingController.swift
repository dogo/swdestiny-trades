//
//  SwiftUIHostingController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import UIKit

final class SwiftUIHostingController<Content: View>: UIHostingController<Content> {
    var onError: ((Error) -> Void)?
    var onViewDidAppear: (() -> Void)?
    var onViewDidDisappear: (() -> Void)?
    var shouldAutoResize: Bool = true
    var customBackgroundColor: UIColor?
    init(
        rootView: Content,
        onError: ((Error) -> Void)? = nil,
        onViewDidAppear: (() -> Void)? = nil,
        onViewDidDisappear: (() -> Void)? = nil
    ) {
        self.onError = onError
        self.onViewDidAppear = onViewDidAppear
        self.onViewDidDisappear = onViewDidDisappear

        super.init(rootView: rootView)

        setupHostingController()
    }

    @MainActor
    dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHostingController()
    }

    private func setupHostingController() {
        if shouldAutoResize {
            sizingOptions = [.intrinsicContentSize]
        }
        if let backgroundColor = customBackgroundColor {
            view.backgroundColor = backgroundColor
        }
        setupErrorHandling()
    }

    private func setupErrorHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSwiftUIError(_:)),
            name: .swiftUIError,
            object: nil
        )
    }

    @objc
    private func handleSwiftUIError(_ notification: Notification) {
        if let error = notification.object as? Error {
            onError?(error)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear?()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onViewDidDisappear?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundColor = customBackgroundColor {
            view.backgroundColor = backgroundColor
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

enum SwiftUIHostingControllerFactory {
    static func modal<Content: View>(
        _ content: Content,
        backgroundColor: UIColor? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> SwiftUIHostingController<Content> {
        let controller = SwiftUIHostingController(
            rootView: content,
            onError: onError
        )
        controller.customBackgroundColor = backgroundColor
        controller.modalPresentationStyle = .pageSheet
        return controller
    }

    static func navigation<Content: View>(
        _ content: Content,
        backgroundColor: UIColor? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> SwiftUIHostingController<Content> {
        let controller = SwiftUIHostingController(
            rootView: content,
            onError: onError
        )
        controller.customBackgroundColor = backgroundColor
        controller.shouldAutoResize = false
        return controller
    }

    static func tabBarItem<Content: View>(
        _ content: Content,
        title: String,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        backgroundColor: UIColor? = nil,
        onError: ((Error) -> Void)? = nil
    ) -> SwiftUIHostingController<Content> {
        let controller = SwiftUIHostingController(
            rootView: content,
            onError: onError
        )
        controller.customBackgroundColor = backgroundColor
        controller.tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
        return controller
    }
}

struct ErrorBoundary<Content: View>: View {
    let content: Content
    let onError: (Error) -> Void

    @State private var error: Error?

    init(@ViewBuilder content: () -> Content, onError: @escaping (Error) -> Void) {
        self.content = content()
        self.onError = onError
    }

    var body: some View {
        if let error {
            ErrorView(message: error.localizedDescription) {
                self.error = nil
            }
        } else {
            content
                .onReceive(NotificationCenter.default.publisher(for: .swiftUIError)) { notification in
                    if let error = notification.object as? Error {
                        self.error = error
                        onError(error)
                    }
                }
        }
    }
}

extension Notification.Name {
    static let swiftUIError = Notification.Name("SwiftUIError")
}

enum SwiftUIIntegrationError: Error, LocalizedError {
    case hostingControllerCreationFailed(String)
    case viewRenderingFailed(String)
    case stateUpdateFailed(String)

    var errorDescription: String? {
        switch self {
        case let .hostingControllerCreationFailed(message):
            return "Failed to create SwiftUI hosting controller: \(message)"
        case let .viewRenderingFailed(message):
            return "Failed to render SwiftUI view: \(message)"
        case let .stateUpdateFailed(message):
            return "Failed to update SwiftUI state: \(message)"
        }
    }
}
