//
//  ToastQueue.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import SwiftUI

@Observable
@MainActor
final class ToastQueue {
    private(set) var current: ToastItem?
    private var queue: [ToastItem] = []

    func enqueue(title: String, message: String, type: ToastType, duration: TimeInterval = 2.0, onDismiss: (() -> Void)? = nil) {
        let item = ToastItem(
            title: title,
            message: message,
            type: type,
            duration: duration,
            onDismiss: onDismiss
        )
        enqueue(item)
    }

    private func enqueue(_ item: ToastItem) {
        if current == nil {
            current = item
        } else {
            queue.append(item)
        }
    }

    func cancel(id: UUID) {
        if current?.id == id {
            advance()
        } else {
            queue.removeAll { $0.id == id }
        }
    }

    func cancelAll() {
        queue.removeAll()
        current = nil
    }

    func advance() {
        let dismissed = current
        current = queue.isEmpty ? nil : queue.removeFirst()
        if let callback = dismissed?.onDismiss {
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(300))
                callback()
            }
        }
    }
}

// MARK: - View Extension

extension View {
    func toastQueue(_ queue: ToastQueue) -> some View {
        modifier(ToastQueueModifier(queue: queue))
    }
}

// MARK: - ViewModifier

private struct ToastQueueModifier: ViewModifier {
    let queue: ToastQueue

    func body(content: Content) -> some View {
        content
            .background {
                WindowToastAnchor(queue: queue)
                    .frame(width: 0, height: 0)
                    .allowsHitTesting(false)
            }
            .onDisappear {
                // The toast lives in the key window, so it doesn't take part in the
                // navigation pop. Clear it as the screen leaves so it doesn't float
                // on top during the transition (and doesn't re-appear on return).
                queue.cancelAll()
            }
    }
}

// MARK: - Toast Presenter Content

private struct ToastPresenterContent: View {
    let item: ToastItem
    let onDismiss: () -> Void

    var body: some View {
        ToastView(
            item: item,
            onDismiss: onDismiss,
            onTap: onDismiss,
            onSwipeUp: onDismiss
        )
    }
}

// MARK: - Passthrough Container

/// Full-screen container that only captures touches landing on its subviews
/// (the toast). Touches in empty areas return `nil`, so they pass through to
/// the app's UI underneath instead of being swallowed by the overlay.
private final class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit === self ? nil : hit
    }
}

// MARK: - UIKit Window Presenter

private struct WindowToastAnchor: UIViewRepresentable {
    let queue: ToastQueue

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        context.coordinator.anchor
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.sync(with: queue)
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.removeToast(animated: false)
    }

    @MainActor
    final class Coordinator {
        let anchor = UIView()
        private var hostVC: UIHostingController<ToastPresenterContent>?
        private var presenterView: PassthroughView?
        private var presentedItemID: UUID?
        private var isObserving = false

        func sync(with queue: ToastQueue) {
            if let item = queue.current, item.id != presentedItemID {
                schedulePresentation(item: item, onDismiss: queue.advance)
            } else if queue.current == nil {
                removeToast()
            }
            scheduleObservation(queue)
        }

        private func scheduleObservation(_ queue: ToastQueue) {
            guard !isObserving else { return }
            isObserving = true
            withObservationTracking {
                _ = queue.current
            } onChange: { [weak self] in
                Task { @MainActor [weak self] in
                    self?.isObserving = false
                    self?.sync(with: queue)
                }
            }
        }

        private func schedulePresentation(item: ToastItem, onDismiss: @escaping () -> Void) {
            guard let window = keyWindow() ?? anchor.window else {
                Task { @MainActor [weak self] in
                    self?.schedulePresentation(item: item, onDismiss: onDismiss)
                }
                return
            }
            present(item: item, onDismiss: onDismiss, in: window)
        }

        private func present(item: ToastItem, onDismiss: @escaping () -> Void, in window: UIWindow) {
            removeToast(animated: false)
            presentedItemID = item.id

            let content = ToastPresenterContent(
                item: item,
                onDismiss: onDismiss
            )

            let hostController = UIHostingController(rootView: content)
            hostController.view.backgroundColor = .clear

            let container = PassthroughView()
            container.backgroundColor = .clear
            container.frame = window.bounds
            container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.alpha = 0

            hostController.view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(hostController.view)
            NSLayoutConstraint.activate([
                hostController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                hostController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
                hostController.view.topAnchor.constraint(
                    equalTo: container.topAnchor,
                    constant: toastTopOffset(in: window)
                )
            ])

            window.addSubview(container)
            container.layoutIfNeeded()
            hostVC = hostController
            presenterView = container

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                container.alpha = 1
            }
        }

        /// Top inset for the toast, measured from the window's top edge. Uses the
        /// bottom of the visible navigation bar as reference so the toast sits just
        /// below it, regardless of large titles, search bars, or notch height.
        /// Falls back to the safe area when no navigation bar is present.
        private func toastTopOffset(in window: UIWindow) -> CGFloat {
            let referenceBottom = visibleNavigationBars(in: window)
                .map { $0.convert($0.bounds, to: window).maxY }
                .max()

            return (referenceBottom ?? window.safeAreaInsets.top) + 8
        }

        private func visibleNavigationBars(in root: UIView) -> [UINavigationBar] {
            var result: [UINavigationBar] = []
            if let navBar = root as? UINavigationBar,
               navBar.window != nil,
               !navBar.isHidden,
               navBar.alpha > 0.01,
               !navBar.bounds.isEmpty {
                result.append(navBar)
            }
            for subview in root.subviews {
                result += visibleNavigationBars(in: subview)
            }
            return result
        }

        func removeToast(animated: Bool = true) {
            presentedItemID = nil
            guard let container = presenterView else { return }
            hostVC = nil
            presenterView = nil
            if animated {
                UIView.animate(withDuration: 0.2) {
                    container.alpha = 0
                } completion: { _ in
                    container.removeFromSuperview()
                }
            } else {
                container.removeFromSuperview()
            }
        }

        private func keyWindow() -> UIWindow? {
            let foregroundScenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }

            return foregroundScenes
                .flatMap(\.windows)
                .first { window in
                    window.isKeyWindow
                        && !window.isHidden
                        && window.windowLevel == .normal
                        && !window.bounds.isEmpty
                } ?? foregroundScenes
                .flatMap(\.windows)
                .first { window in
                    !window.isHidden
                        && window.windowLevel == .normal
                        && !window.bounds.isEmpty
                }
        }
    }
}
