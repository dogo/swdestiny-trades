//
//  ScanReviewSheet.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

/// Review the cards found in a capture and pick which ones to add to the collection.
struct ScanReviewSheet: View {

    let viewModel: CardScannerViewModel
    let onSearchManually: () -> Void

    @Environment(\.dismiss) private var dismiss

    private var noneRecognized: Bool {
        viewModel.reviewCandidates.allSatisfy { !$0.isRecognized }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.reviewCandidates) { candidate in
                    row(candidate)
                }

                if noneRecognized {
                    Button {
                        dismiss()
                        onSearchManually()
                    } label: {
                        Label(L10n.scanSearchManually, systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationTitle(L10n.scanReviewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.scanAddSelected(viewModel.selectedCount)) {
                        viewModel.addSelected()
                    }
                    .disabled(viewModel.selectedCount == 0)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func row(_ candidate: ScanCandidate) -> some View {
        HStack(spacing: 12) {
            Image(decorative: candidate.crop, scale: 1.0)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 62)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            if let match = candidate.chosenMatch {
                VStack(alignment: .leading, spacing: 2) {
                    Text(match.card.name)
                        .font(.subheadline.weight(.medium))
                    Text(match.card.setName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(L10n.scanConfidence(match.confidencePercent))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                matchControls(for: candidate)
            } else {
                Text(L10n.scanNotRecognized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func matchControls(for candidate: ScanCandidate) -> some View {
        if candidate.matches.count > 1 {
            Menu {
                ForEach(Array(candidate.matches.enumerated()), id: \.offset) { index, option in
                    Button {
                        viewModel.choose(candidate, index: index)
                    } label: {
                        Text("\(option.card.name) · \(option.card.setName) — \(option.confidencePercent)%")
                    }
                }
            } label: {
                Image(systemName: "chevron.down.circle")
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(L10n.scanChooseMatch)
        }

        Button {
            viewModel.toggle(candidate)
        } label: {
            Image(systemName: candidate.isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(candidate.isSelected ? Color.accentColor : Color.secondary)
        }
        .buttonStyle(.plain)
    }
}
