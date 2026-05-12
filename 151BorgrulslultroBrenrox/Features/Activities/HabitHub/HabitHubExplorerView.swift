//
//  HabitHubExplorerView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct HabitWeeklyPie: View {
    var ratio: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.appTextSecondary.opacity(0.25), lineWidth: 12)
                .frame(width: 140, height: 140)
            Circle()
                .trim(from: 0, to: CGFloat(min(max(ratio, 0), 1)))
                .stroke(Color.appAccent, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140)
                .animation(.easeInOut(duration: 0.35), value: ratio)
            Text("\(Int((min(max(ratio, 0), 1)) * 100)))%")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.vertical, 8)
    }
}

struct HabitHubExplorerView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @Environment(\.dismiss) private var dismiss

    @StateObject private var model = HabitHubViewModel()
    @State private var outcome: ActivityOutcome?

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Habit-Hub Explorer")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("Track tactile rituals with toggles, weekly targets, and a live rhythm ring. Targets are capped per week so the pie stays honest—raise counts only when your calendar truly has room.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(8)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(CultureTipsProvider.ambientLine(seed: appState.habitItems.count + 21))
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary.opacity(0.95))
                        .lineLimit(5)
                        .minimumScaleFactor(0.7)

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Weekly rhythm")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Color.appTextPrimary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Text("Exploration streak: \(appState.culturalStreak)")
                                .font(.footnote)
                                .foregroundStyle(Color.appTextSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        Spacer()
                        HabitWeeklyPie(ratio: appState.habitWeeklyProgressRatio())
                    }
                    .padding(16)
                    .appDepthSurface(cornerRadius: 18, shadow: .soft)

                    if let banner = model.banner {
                        Text(banner)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Color.appTextPrimary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .appDepthSurfaceTinted(cornerRadius: 12, tint: Color.appPrimary, shadow: .none)
                    }

                    VStack(spacing: 12) {
                        Text("Cultural cadence")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.appTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(appState.habitItems) { item in
                            habitEditor(for: item.id)
                        }
                    }
                    .padding(12)
                    .appDepthSurface(cornerRadius: 16, shadow: .soft)

                    Button {
                        let stars = model.captureWeeklyAward(using: appState)
                        if stars > 0 {
                            outcome = ActivityOutcome(
                                id: UUID().uuidString,
                                headline: "Weekly rhythm sealed",
                                detail: "Habit cadence met the weekly arc with consistency.",
                                stars: stars,
                                preview: "Collections tab highlights newly eligible cultural decks.",
                                cultureTip: CultureTipsProvider.tip(for: .habit, variant: stars)
                            )
                        }
                    } label: {
                        Text("Record weekly summary")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .buttonStyle(AppPrimaryButtonStyle())
                }
                .padding(16)
            }
            .appDepthScrollBackdrop()
            .onAppear {
                appState.reconcileHabitWeekIfNeeded()
            }

            if let outcome {
                ActivityResultView(
                    outcome: outcome,
                    onReplay: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                            self.outcome = nil
                        }
                        model.banner = nil
                    },
                    onNextCollection: {
                        tabCoordinator.requestTab(.collections)
                        dismiss()
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.35), value: outcome != nil)
    }

    private func habitEditor(for id: UUID) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle(isOn: isActiveBinding(for: id)) {
                Text(title(for: id))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .tint(Color.appPrimary)

            Stepper(value: weeklyTargetBinding(for: id), in: 1...7) {
                Label("Weekly target: \(weeklyTarget(for: id))", systemImage: "calendar")
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Stepper(value: weekProgressBinding(for: id), in: 0...max(weeklyTarget(for: id), 1)) {
                Label("Logged sessions: \(weekProgress(for: id))", systemImage: "waveform.path.ecg")
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(.vertical, 6)
    }

    private func title(for id: UUID) -> String {
        appState.habitItems.first(where: { $0.id == id })?.title ?? ""
    }

    private func weeklyTarget(for id: UUID) -> Int {
        appState.habitItems.first(where: { $0.id == id })?.weeklyTarget ?? 1
    }

    private func weekProgress(for id: UUID) -> Int {
        appState.habitItems.first(where: { $0.id == id })?.weekProgress ?? 0
    }

    private func isActiveBinding(for id: UUID) -> Binding<Bool> {
        Binding(
            get: { appState.habitItems.first(where: { $0.id == id })?.isActive ?? false },
            set: { newValue in
                guard let index = appState.habitItems.firstIndex(where: { $0.id == id }) else { return }
                var copy = appState.habitItems[index]
                copy.isActive = newValue
                appState.habitItems[index] = copy
            }
        )
    }

    private func weeklyTargetBinding(for id: UUID) -> Binding<Int> {
        Binding(
            get: { appState.habitItems.first(where: { $0.id == id })?.weeklyTarget ?? 1 },
            set: { newValue in
                guard let index = appState.habitItems.firstIndex(where: { $0.id == id }) else { return }
                var copy = appState.habitItems[index]
                copy.weeklyTarget = newValue
                if copy.weekProgress > copy.weeklyTarget {
                    copy.weekProgress = copy.weeklyTarget
                }
                appState.habitItems[index] = copy
            }
        )
    }

    private func weekProgressBinding(for id: UUID) -> Binding<Int> {
        Binding(
            get: { appState.habitItems.first(where: { $0.id == id })?.weekProgress ?? 0 },
            set: { newValue in
                guard let index = appState.habitItems.firstIndex(where: { $0.id == id }) else { return }
                var copy = appState.habitItems[index]
                copy.weekProgress = min(newValue, max(1, copy.weeklyTarget))
                appState.habitItems[index] = copy
            }
        )
    }
}
