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
    let title: String
    let message: String
    let type: ToastType
    @Binding var isPresented: Bool
    var duration: TimeInterval = 1.5
    var onDismiss: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)

                Image(systemName: type.icon)
                    .foregroundStyle(type.backgroundColor)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(message)
                    .foregroundStyle(.white.opacity(0.95))
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .clipShape(.rect(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
        .task {
            do {
                try await Task.sleep(for: .seconds(duration))
                withAnimation {
                    isPresented = false
                }
                if let onDismiss {
                    try await Task.sleep(for: .milliseconds(300))
                    onDismiss()
                }
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
            ToastView(title: "Added", message: "Captain Phasma", type: .success, isPresented: .constant(true))
            ToastView(title: "Error", message: "An error occurred", type: .error, isPresented: .constant(true))
            ToastView(title: "Info", message: "Information message", type: .info, isPresented: .constant(true))
        }
    }
}
