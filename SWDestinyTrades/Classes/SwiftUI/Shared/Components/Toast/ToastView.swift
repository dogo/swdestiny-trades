//
//  ToastView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 13/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
struct ToastView: View {
    let item: ToastItem
    var onDismiss: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)

                Image(systemName: item.type.icon)
                    .foregroundStyle(item.type.backgroundColor)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .bold()

                Text(item.message)
                    .foregroundStyle(.white.opacity(0.95))
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(item.type.backgroundColor)
        .clipShape(.rect(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
        .task {
            do {
                try await Task.sleep(for: .seconds(item.duration))
                onDismiss?()
            } catch {
                // Task was cancelled, no action needed
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            ToastView(item: ToastItem(title: "Added", message: "Captain Phasma", type: .success))
            ToastView(item: ToastItem(title: "Error", message: "An error occurred", type: .error))
            ToastView(item: ToastItem(title: "Info", message: "Information message", type: .info))
        }
    }
}
