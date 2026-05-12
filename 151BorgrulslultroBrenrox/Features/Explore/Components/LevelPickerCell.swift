//
//  LevelPickerCell.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

/// Shared chrome for atlas / lattice level pickers (not a UITableView cell — SwiftUI layout).
struct LevelPickerCell: View {
    let levelIndex: Int
    let totalLevels: Int
    let title: String
    let tagline: String
    let isUnlocked: Bool
    let isCleared: Bool
    let accent: Color
    let glyphSystemImage: String

    private var displayNumber: Int { levelIndex + 1 }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(railColor)
                .frame(width: 5)
                .padding(.vertical, 6)
                .padding(.trailing, 12)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                accent.opacity(isUnlocked ? 0.55 : 0.22),
                                accent.opacity(isUnlocked ? 0.28 : 0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.appTextPrimary.opacity(0.1), lineWidth: 1)
                    }
                Image(systemName: glyphSystemImage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(isUnlocked ? Color.appTextPrimary : Color.appTextSecondary)
                    .opacity(isUnlocked ? 1 : 0.55)
            }
            .overlay(alignment: .bottomTrailing) {
                Text("\(displayNumber)")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.appTextPrimary)
                    .padding(4)
                    .background(
                        Circle()
                            .fill(Color.appBackground.opacity(0.92))
                    )
                    .offset(x: 4, y: 4)
            }
            .padding(.trailing, 14)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)

                Text(tagline)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)

                stepTicks
            }

            Spacer(minLength: 10)

            VStack(alignment: .trailing, spacing: 8) {
                statusCapsule
                Image(systemName: trailingIcon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(trailingTint)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .appDepthSurface(
            cornerRadius: 20,
            shadow: isUnlocked ? .soft : .none,
            stroke: isUnlocked ? accent.opacity(0.24) : Color.appTextSecondary.opacity(0.14)
        )
        .opacity(isUnlocked ? 1 : 0.92)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }

    private var railColor: Color {
        if !isUnlocked { return Color.appTextSecondary.opacity(0.35) }
        if isCleared { return accent.opacity(0.85) }
        return accent.opacity(0.55)
    }

    private var stepTicks: some View {
        HStack(spacing: 5) {
            ForEach(0..<totalLevels, id: \.self) { i in
                Capsule()
                    .fill(tickFill(for: i))
                    .frame(width: i == levelIndex ? 16 : 7, height: 4)
            }
        }
        .accessibilityHidden(true)
    }

    private var statusCapsule: some View {
        Text(statusText)
            .font(.caption2.weight(.heavy))
            .foregroundStyle(statusForeground)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(statusBackground)
            )
    }

    private var statusText: String {
        if !isUnlocked { return "Locked" }
        if isCleared { return "Cleared" }
        return "Open"
    }

    private var statusForeground: Color {
        if !isUnlocked { return Color.appTextSecondary }
        if isCleared { return Color.appTextPrimary }
        return Color.appTextPrimary
    }

    private var statusBackground: Color {
        if !isUnlocked { return Color.appBackground.opacity(0.45) }
        if isCleared { return accent.opacity(0.32) }
        return accent.opacity(0.28)
    }

    private var trailingIcon: String {
        isUnlocked ? "chevron.right" : "lock.fill"
    }

    private var trailingTint: Color {
        isUnlocked ? accent : Color.appTextSecondary.opacity(0.75)
    }

    private var accessibilitySummary: String {
        let state = !isUnlocked ? "locked" : (isCleared ? "cleared, available to replay" : "open")
        return "\(title). \(tagline). \(state)."
    }

    private func tickFill(for i: Int) -> Color {
        if i < levelIndex { return accent.opacity(0.42) }
        if i == levelIndex { return accent.opacity(isUnlocked ? 0.95 : 0.38) }
        return Color.appTextSecondary.opacity(0.14)
    }
}

struct LevelPickerLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}
