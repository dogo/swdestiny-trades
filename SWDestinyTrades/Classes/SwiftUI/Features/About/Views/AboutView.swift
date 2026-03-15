//
//  AboutView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @State private var viewModel: AboutViewModel

    init(viewModel: AboutViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? AboutViewModel())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(asset: Asset.Logo.largeIconBlack)
                    .renderingMode(.template)
                    .foregroundStyle(.primary)
                    .frame(width: 280, height: 150)
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 34)

                HStack {
                    Spacer()
                    Text(L10n.version(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 15)
                }

                VStack(alignment: .leading, spacing: 16) {
                    aboutTextWithLink
                }
                .padding(.horizontal, 12)

                Spacer()
            }
        }
        .navigationTitle(L10n.about)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
    }

    private var aboutTextWithLink: some View {
        let aboutText = L10n.aboutText(L10n.swdestinydbWebsite)
        let components = aboutText.components(separatedBy: L10n.swdestinydbWebsite)

        return VStack(alignment: .leading, spacing: 8) {
            if components.count >= 2 {
                Text(components[0])
                    .font(.body)

                Button {
                    viewModel.openWebsite(using: navigationCoordinator)
                } label: {
                    Text(L10n.swdestinydbWebsite)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .underline()
                }
                .buttonStyle(.plain)

                Text(components[1])
                    .font(.body)
                    .foregroundStyle(.secondary)
            } else {
                Text(aboutText)
                    .font(.body)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
    .environment(NavigationCoordinator())
}
