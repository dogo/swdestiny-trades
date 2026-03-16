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
                    AboutTextSection {
                        viewModel.openWebsite(using: navigationCoordinator)
                    }
                }
                .padding(.horizontal, 12)

                Spacer()
            }
        }
        .navigationTitle(L10n.about)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
    .environment(NavigationCoordinator())
}
