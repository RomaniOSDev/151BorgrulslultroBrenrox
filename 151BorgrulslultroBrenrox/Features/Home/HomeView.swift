//
//  HomeView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator

    private var greetingLine: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Welcome back"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    heroWidget

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        visualStatTile(value: "\(appState.totalStars)", label: "Stars", icon: "star.fill", tint: Color.appAccent) {
                            tabCoordinator.requestTab(.explore)
                        }
                        visualStatTile(value: "\(appState.culturalStreak)d", label: "Streak", icon: "flame.fill", tint: Color.appPrimary) {
                            tabCoordinator.requestTab(.journeys)
                        }
                        visualStatTile(
                            value: "\(appState.cartographerStagesCleared)/5",
                            label: "Atlas",
                            icon: "map.fill",
                            tint: Color.appPrimary.opacity(0.95)
                        ) {
                            tabCoordinator.requestTab(.explore)
                        }
                        visualStatTile(
                            value: "\(appState.silhouetteStagesCleared)/3",
                            label: "Lattice",
                            icon: "square.grid.3x3.fill",
                            tint: Color.appAccent.opacity(0.95)
                        ) {
                            tabCoordinator.requestTab(.explore)
                        }
                    }

                    habitRingWidget

                    WeeklyProgressSection(isCompact: true)

                    iconShortcutsRow

                    suggestionVisualCard

                    if let latest = appState.sessionLog.first {
                        recentSessionVisual(entry: latest)
                    }

                    journalVisualCard
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .appDepthScrollBackdrop()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(Color.appPrimary)
                        Text("Home")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.appTextPrimary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.appAccent)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel(Text("Settings"))
                }
            }
        }
        .tint(Color.appPrimary)
        .onAppear {
            appState.refreshWeeklyScopedState()
            appState.reconcileHabitWeekIfNeeded()
        }
    }

    private var heroWidget: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appPrimary.opacity(0.5),
                            Color.appAccent.opacity(0.35),
                            Color.appSurface.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Decorative symbols (visual texture, not photos)
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.12))
                        .rotationEffect(.degrees(-18))
                    Image(systemName: "map.circle.fill")
                        .font(.system(size: 72, weight: .light))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.1))
                }
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: "camera.macro")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.1))
                    Spacer()
                    Image(systemName: "sun.horizon.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.11))
                }
            }
            .padding(18)

            HStack(alignment: .bottom, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.appBackground.opacity(0.45))
                        .frame(width: 56, height: 56)
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingLine)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                    Text("Studio hub")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.75))
                        .textCase(.uppercase)
                        .tracking(0.6)
                }
                Spacer(minLength: 0)
            }
            .padding(20)
        }
        .frame(minHeight: 148)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.appTextPrimary.opacity(0.14),
                            Color.appTextPrimary.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.appTextPrimary.opacity(0.1), radius: 18, x: 0, y: 8)
    }

    private func visualStatTile(
        value: String,
        label: String,
        icon: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(height: 40)
                Text(value)
                    .font(.title.weight(.heavy))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(label)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.appTextSecondary)
                    .textCase(.uppercase)
                    .tracking(0.4)
                    .lineLimit(1)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(Color.appTextSecondary.opacity(0.55))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 8)
            .appDepthSurface(cornerRadius: 20, shadow: .soft, stroke: tint.opacity(0.28))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("\(label), \(value)"))
        .accessibilityHint(Text("Opens related tab"))
    }

    private var habitRingWidget: some View {
        let ratio = appState.habitWeeklyProgressRatio()
        let active = appState.habitItems.filter(\.isActive).count

        return Button {
            tabCoordinator.requestTab(.explore)
        } label: {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.2), lineWidth: 8)
                        .frame(width: 72, height: 72)
                    Circle()
                        .trim(from: 0, to: ratio)
                        .stroke(Color.appPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Habits")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("\(Int((ratio * 100).rounded()))% · \(active) on")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.appPrimary.opacity(0.65))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 20, shadow: .soft, stroke: Color.appPrimary.opacity(0.18))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Habits progress \(Int((ratio * 100).rounded())) percent"))
    }

    private var iconShortcutsRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "square.grid.4x3.fill")
                    .foregroundStyle(Color.appAccent)
                Text("Go")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Color.appTextSecondary)
                    .textCase(.uppercase)
            }
            HStack(spacing: 10) {
                iconJump(icon: "globe.europe.africa.fill", tab: .explore)
                iconJump(icon: "square.grid.2x2.fill", tab: .collections)
                iconJump(icon: "point.topleft.down.curvedto.point.bottomright.up", tab: .journeys)
                NavigationLink {
                    FieldJournalView()
                } label: {
                    shortcutIconOnly(systemName: "book.closed.fill")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 20, shadow: .soft)
    }

    private func iconJump(icon: String, tab: MainTab) -> some View {
        Button {
            tabCoordinator.requestTab(tab)
        } label: {
            shortcutIconOnly(systemName: icon)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(tab.title))
    }

    private func shortcutIconOnly(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.appAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appPrimary.opacity(0.28),
                                Color.appPrimary.opacity(0.14)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.appTextPrimary.opacity(0.08), lineWidth: 1)
            )
    }

    private var suggestionVisualCard: some View {
        let pack = nextSuggestionVisual
        return Button {
            tabCoordinator.requestTab(pack.tab)
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.appPrimary.opacity(0.28))
                        .frame(width: 72, height: 72)
                    Image(systemName: pack.symbol)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(.uppercase)
                    Text(pack.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(Color.appPrimary.opacity(0.7))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 22, shadow: .soft, stroke: Color.appAccent.opacity(0.22))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Suggested: \(pack.title)"))
    }

    private var nextSuggestionVisual: (title: String, symbol: String, tab: MainTab) {
        if appState.cartographerStagesCleared < 5 {
            return ("Atlas route", "map.fill", .explore)
        }
        if appState.silhouetteStagesCleared < 3 {
            return ("Story lattice", "square.grid.3x3.fill", .explore)
        }
        if appState.habitWeeklyProgressRatio() < 0.999 {
            return ("Habit hub", "waveform.path", .explore)
        }
        if appState.viewedInsightCardKeys.count < 6 {
            return ("Read decks", "rectangle.stack.fill", .collections)
        }
        return ("Journeys log", "list.clipboard.fill", .journeys)
    }

    private func recentSessionVisual(entry: LoggedSessionEntry) -> some View {
        Button {
            tabCoordinator.requestTab(.journeys)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 56, height: 56)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.appPrimary.opacity(0.22)))
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.detailTitle)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.appAccent)
                        Text("\(entry.starsEarned)")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(Color.appAccent)
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 20, shadow: .soft)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Latest session \(entry.detailTitle)"))
    }

    private var journalVisualCard: some View {
        NavigationLink {
            FieldJournalView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "pencil.and.list.clipboard")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 56, height: 56)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.appAccent.opacity(0.18)))
                VStack(alignment: .leading, spacing: 6) {
                    Text("Journal")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    if let snippet = appState.journalEntries.first?.body.split(separator: "\n").first {
                        Text(String(snippet))
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.appPrimary)
                            Text("Add note")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(Color.appPrimary.opacity(0.55))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 20, shadow: .soft)
        }
        .buttonStyle(.plain)
    }
}
