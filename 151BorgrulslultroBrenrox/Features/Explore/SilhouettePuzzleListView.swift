//
//  SilhouettePuzzleListView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct SilhouettePuzzleListView: View {
    @EnvironmentObject private var appState: TravelAppState

    private static let latticeTaglines: [String] = [
        "Intro · veil & tap",
        "Twins · mirrored cells",
        "Curtain · slow lifts"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerBlock

                if appState.allSilhouettePuzzlesCleared {
                    completionBanner(text: "All narrative lattices are complete. Replay to chase a cleaner tile path.")
                }

                LazyVStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        let unlocked = appState.isSilhouettePuzzleUnlocked(index)
                        let cleared = appState.silhouetteStagesCleared > index
                        let tagline = Self.latticeTaglines[min(index, Self.latticeTaglines.count - 1)]

                        Group {
                            if unlocked {
                                NavigationLink {
                                    StorySilhouetteView(puzzleIndex: index)
                                } label: {
                                    LevelPickerCell(
                                        levelIndex: index,
                                        totalLevels: 3,
                                        title: "Narrative \(index + 1)",
                                        tagline: tagline,
                                        isUnlocked: true,
                                        isCleared: cleared,
                                        accent: Color.appAccent,
                                        glyphSystemImage: "square.grid.3x3.fill"
                                    )
                                }
                                .buttonStyle(LevelPickerLinkButtonStyle())
                            } else {
                                LevelPickerCell(
                                    levelIndex: index,
                                    totalLevels: 3,
                                    title: "Narrative \(index + 1)",
                                    tagline: tagline,
                                    isUnlocked: false,
                                    isCleared: false,
                                    accent: Color.appAccent,
                                    glyphSystemImage: "square.grid.3x3.fill"
                                )
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .appDepthScrollBackdrop()
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerBlock: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "square.grid.3x3.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.appAccent.opacity(0.18)))
            VStack(alignment: .leading, spacing: 6) {
                Text("Story Silhouette")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                Text("Tiles · veils · patient taps")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appAccent.opacity(0.26),
                            Color.appSurface.opacity(0.58)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.appAccent.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.08), radius: 14, x: 0, y: 6)
    }

    private func completionBanner(text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.appAccent)
            Text(text)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appPrimary.opacity(0.24))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.appAccent.opacity(0.28), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}
