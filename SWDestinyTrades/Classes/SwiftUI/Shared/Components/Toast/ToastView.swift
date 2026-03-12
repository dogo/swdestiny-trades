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
                    .foregroundColor(type.backgroundColor)
                    .font(.system(size: 20, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(message)
                    .foregroundColor(.white.opacity(0.95))
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
                try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                withAnimation {
                    isPresented = false
                }
                if let onDismiss {
                    try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
                    onDismiss()
                }
            } catch {
                // Task was cancelled, no action needed
            }
        }
    }
}

enum ToastType {
    case success
    case error
    case info

    var icon: String {
        switch self {
        case .success:
            return "checkmark"
        case .error:
            return "xmark"
        case .info:
            return "info"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success:
            return Color(red: 0.4, green: 0.65, blue: 0.2)
        case .error:
            return Color.red
        case .info:
            return Color.blue
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
