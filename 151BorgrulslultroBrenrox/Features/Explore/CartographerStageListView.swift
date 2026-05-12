//
//  CartographerStageListView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct CartographerStageListView: View {
    @EnvironmentObject private var appState: TravelAppState

    private static let routeTaglines: [String] = [
        "Harbor · wide anchors",
        "Market · read crowding",
        "Climb · short tether",
        "Bridges · long spans",
        "Master · few retries"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerBlock

                if appState.allCartographerStagesCleared {
                    completionBanner(text: "Every atlas route is cleared. Replay any stage to refine lines.")
                }

                LazyVStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { index in
                        let unlocked = appState.isCartographerStageUnlocked(index)
                        let cleared = appState.cartographerStagesCleared > index
                        let tagline = Self.routeTaglines[min(index, Self.routeTaglines.count - 1)]

                        Group {
                            if unlocked {
                                NavigationLink {
                                    CultureCartographerView(stageIndex: index)
                                } label: {
                                    LevelPickerCell(
                                        levelIndex: index,
                                        totalLevels: 5,
                                        title: "Route \(index + 1)",
                                        tagline: tagline,
                                        isUnlocked: true,
                                        isCleared: cleared,
                                        accent: Color.appPrimary,
                                        glyphSystemImage: "point.topleft.down.curvedto.point.bottomright.up"
                                    )
                                }
                                .buttonStyle(LevelPickerLinkButtonStyle())
                            } else {
                                LevelPickerCell(
                                    levelIndex: index,
                                    totalLevels: 5,
                                    title: "Route \(index + 1)",
                                    tagline: tagline,
                                    isUnlocked: false,
                                    isCleared: false,
                                    accent: Color.appPrimary,
                                    glyphSystemImage: "point.topleft.down.curvedto.point.bottomright.up"
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
            Image(systemName: "map.circle.fill")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.appPrimary.opacity(0.22)))
            VStack(alignment: .leading, spacing: 6) {
                Text("Culture Cartographer")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                Text("Markers · timer · calm drags")
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
                            Color.appPrimary.opacity(0.32),
                            Color.appSurface.opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.appPrimary.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.08), radius: 14, x: 0, y: 6)
    }

    private func completionBanner(text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "seal.fill")
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
                .fill(Color.appPrimary.opacity(0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.appAccent.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}
