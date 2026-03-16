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
            .overlay(alignment: .top) {
                if let item = queue.current {
                    ToastView(item: item, onDismiss: queue.advance)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .id(item.id)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: queue.current?.id)
    }
}
