//
//  CardScannerView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardScannerView: View {

    @State private var viewModel = CardScannerViewModel()
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            switch viewModel.cameraState {
            case .authorized:
                cameraContent
            case .denied:
                deniedContent
            case .idle:
                Color.black
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(L10n.scanCardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toastQueue(viewModel.toastQueue)
        .sheet(isPresented: $viewModel.isReviewPresented) {
            ScanReviewSheet(viewModel: viewModel) {
                navigationCoordinator.navigate(to: .addCard)
            }
        }
        .task { await viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }

    // MARK: - Camera

    private var cameraContent: some View {
        ZStack {
            Color.black

            CameraPreviewView(session: viewModel.cameraSession.captureSession)

            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.9), lineWidth: 3)
                .aspectRatio(ScanFramePipeline.cardAspect, contentMode: .fit)
                .padding(40)
                .allowsHitTesting(false)

            VStack {
                statusBadge
                Spacer()
                captureButton
            }
            .padding()
        }
    }

    @ViewBuilder private var statusBadge: some View {
        switch viewModel.indexState {
        case let .building(progress):
            badge(L10n.scanPreparing(Int(progress * 100)), systemImage: "hourglass")
        case .failed:
            badge(L10n.scanIndexFailed, systemImage: "exclamationmark.triangle.fill")
        case .ready, .idle:
            badge(L10n.scanAlignHint, systemImage: "viewfinder")
        }
    }

    private func badge(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.top, 8)
    }

    private var captureButton: some View {
        Button(action: viewModel.capture) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 68, height: 68)
                Circle()
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 80, height: 80)
            }
        }
        .disabled(!viewModel.isReady)
        .opacity(viewModel.isReady ? 1 : 0.4)
        .padding(.bottom, 32)
        .accessibilityLabel(L10n.scanCapture)
    }

    // MARK: - Permission denied

    private var deniedContent: some View {
        ContentUnavailableView {
            Label(L10n.scanCameraDeniedTitle, systemImage: "camera.fill")
        } description: {
            Text(L10n.scanCameraDeniedMessage)
        } actions: {
            Button(L10n.openSettings) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        CardScannerView()
    }
    .environment(NavigationCoordinator())
}
