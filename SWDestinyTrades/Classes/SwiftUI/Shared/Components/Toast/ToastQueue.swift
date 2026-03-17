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
        let item = ToastItem(title: title, message: message, type: type, duration: duration, onDismiss: onDismiss)
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
    }
}

// MARK: - Toast Presenter Content

private struct ToastPresenterContent: View {
    let item: ToastItem
    let onDismiss: () -> Void
    let topInset: CGFloat

    var body: some View {
        ToastView(item: item, onDismiss: onDismiss)
            .padding(.top, topInset)
            .frame(maxWidth: .infinity)
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
            guard let window = anchor.window ?? keyWindow() else {
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
                onDismiss: onDismiss,
                topInset: window.safeAreaInsets.top + 8
            )

            let hostController = UIHostingController(rootView: content)
            hostController.view.backgroundColor = .clear

            hostController.view.alpha = 0
            hostController.view.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: 1000)
            window.addSubview(hostController.view)
            hostController.view.layoutIfNeeded()

            let fittingSize = CGSize(width: window.bounds.width, height: UIView.layoutFittingCompressedSize.height)
            let height = hostController.view.systemLayoutSizeFitting(
                fittingSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            hostController.view.frame.size.height = height
            hostVC = hostController

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                hostController.view.alpha = 1
            }
        }

        func removeToast(animated: Bool = true) {
            presentedItemID = nil
            guard let hostController = hostVC else { return }
            hostVC = nil
            if animated {
                UIView.animate(withDuration: 0.2) {
                    hostController.view.alpha = 0
                } completion: { _ in
                    hostController.view.removeFromSuperview()
                }
            } else {
                hostController.view.removeFromSuperview()
            }
        }

        private func keyWindow() -> UIWindow? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)
        }
    }
}
