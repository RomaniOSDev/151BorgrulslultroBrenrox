//
//  WeeklyProgressSection.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct WeeklyProgressSection: View {
    @EnvironmentObject private var appState: TravelAppState

    /// When `true`, hides long copy (e.g. on Home dashboard).
    var isCompact: Bool = false

    private let microShortLabels = [
        "Hospitality gesture",
        "Street sound or scent",
        "Craft in public space"
    ]

    private let microSymbols = ["hand.wave.fill", "waveform.circle.fill", "paintpalette.fill"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            routeOfWeekCard
            microChallengeCard
        }
        .onAppear {
            appState.refreshWeeklyScopedState()
        }
    }

    private var routeOfWeekCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.appAccent.opacity(0.22))
                        .frame(width: 44, height: 44)
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly trio path")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                    if !isCompact {
                        Text("Atlas + lattice + habit rhythm this week.")
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)
                    }
                }
                Spacer(minLength: 0)
            }

            ProgressView(value: appState.routeOfWeekProgress)
                .tint(Color.appAccent)

            if !isCompact {
                Text(CultureTipsProvider.ambientLine(seed: appState.routeOfWeekCompletedSteps + appState.totalStars))
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary.opacity(0.9))
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
            }

            HStack(spacing: 10) {
                routePill(title: "Atlas", symbol: "map.fill", done: appState.routeWkCarto)
                routePill(title: "Lattice", symbol: "square.grid.3x3.fill", done: appState.routeWkSil)
                routePill(title: "Rhythm", symbol: "waveform.path", done: appState.routeWkHabit)
            }

            if appState.routeWkStarsClaimed {
                Label("Bonus claimed", systemImage: "checkmark.seal.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
                    .labelStyle(.titleAndIcon)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }

    private func routePill(title: String, symbol: String, done: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: done ? "checkmark.circle.fill" : symbol)
                .foregroundStyle(done ? Color.appAccent : Color.appTextSecondary)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appBackground.opacity(0.55),
                            Color.appBackground.opacity(0.32)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            Capsule()
                .strokeBorder(Color.appTextPrimary.opacity(0.06), lineWidth: 1)
        )
    }

    private var microChallengeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appAccent)
                Text("Weekly reflections")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
            }

            if !isCompact {
                Text("Toggle three micro moments—finish all for a weekly star bonus once.")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
            }

            ForEach(0..<3, id: \.self) { index in
                Toggle(isOn: Binding(
                    get: { appState.isMicroChallengeBitOn(index) },
                    set: { appState.setMicroChallengeBit(index, isOn: $0) }
                )) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: microSymbols[index])
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 36, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.appPrimary.opacity(0.15))
                            )
                        Text(microShortLabels[index])
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                    }
                }
                .tint(Color.appPrimary)
            }

            if appState.microRewardClaimed {
                Label("Bonus logged", systemImage: "star.circle.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
                    .labelStyle(.titleAndIcon)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }
}
