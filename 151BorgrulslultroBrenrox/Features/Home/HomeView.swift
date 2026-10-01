//
//  HomeView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @State private var showSealSheet = false
    @State private var selectedCarry: Set<String> = []
    @State private var residueDraft = ""

    private var greetingLine: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Field morning"
        case 12..<17: return "Midday desk"
        case 17..<22: return "Evening seal window"
        default: return "Night ledger"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    heroWidget

                    if appState.needsMorningBrief {
                        morningBriefCard
                    } else if !appState.activeBriefTitles.isEmpty, appState.briefReviewedDayId == appState.todayDayId {
                        reviewedBriefCard
                    }

                    sealStatusCard

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        visualStatTile(value: "\(appState.totalStars)", label: "Marks", icon: "sparkles", tint: Color.appAccent) {
                            tabCoordinator.requestTab(.explore)
                        }
                        visualStatTile(value: "\(appState.sealStreak)d", label: "Seal streak", icon: "seal.fill", tint: Color.appPrimary) {
                            showSealSheet = true
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
                            value: "\(appState.driftEvents.count)",
                            label: "Drifts",
                            icon: "waveform.path.ecg",
                            tint: Color.appAccent.opacity(0.95)
                        ) {
                            tabCoordinator.requestTab(.journeys)
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
                        Image(systemName: "sun.horizon.fill")
                            .foregroundStyle(Color.appPrimary)
                        Text("Brief")
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
            .sheet(isPresented: $showSealSheet) {
                sealSheet
            }
        }
        .tint(Color.appPrimary)
        .onAppear {
            appState.refreshWeeklyScopedState()
            appState.reconcileHabitWeekIfNeeded()
            if selectedCarry.isEmpty {
                selectedCarry = Set(appState.sealCandidateTitles.prefix(2))
            }
        }
    }

    private var heroWidget: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appPrimary.opacity(0.55),
                            Color.appAccent.opacity(0.32),
                            Color.appSurface.opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "seal.fill")
                        .font(.system(size: 56, weight: .light))
                        .foregroundStyle(Color.appTextPrimary.opacity(0.12))
                }
                Spacer()
            }
            .padding(18)

            HStack(alignment: .bottom, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.appBackground.opacity(0.45))
                        .frame(width: 56, height: 56)
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingLine)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text("Fieldway desk")
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
                .strokeBorder(Color.appTextPrimary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.appTextPrimary.opacity(0.1), radius: 18, x: 0, y: 8)
    }

    private var morningBriefCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Morning Field Brief", systemImage: "sunrise.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
            Text("Yesterday’s sealed waymarks are waiting. Review them before new atlas work.")
                .font(.footnote)
                .foregroundStyle(Color.appTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(appState.activeBriefTitles, id: \.self) { title in
                HStack(spacing: 10) {
                    Image(systemName: "flag.fill")
                        .foregroundStyle(Color.appAccent)
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                }
            }
            Button {
                appState.markMorningBriefReviewed()
            } label: {
                Text("Start with these")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                    .foregroundStyle(Color.appTextPrimary)
                    .appDepthSurface(cornerRadius: 14, shadow: .soft, stroke: Color.appAccent.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 20, shadow: .lifted, stroke: Color.appAccent.opacity(0.35))
    }

    private var reviewedBriefCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Brief locked in", systemImage: "checkmark.seal.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appPrimary)
            Text(appState.activeBriefTitles.joined(separator: " · "))
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 16, shadow: .soft)
    }

    private var sealStatusCard: some View {
        Button {
            showSealSheet = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: appState.isTodaySealed ? "checkmark.seal.fill" : "seal")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 52, height: 52)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.appAccent.opacity(0.18)))
                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.isTodaySealed ? "Day sealed" : "Seal the field day")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(appState.isTodaySealed
                         ? (appState.latestFieldSeal?.residueNote.isEmpty == false
                            ? appState.latestFieldSeal!.residueNote
                            : "Carry list parked for tomorrow’s brief.")
                         : "Pick up to 3 waymarks and leave a residue note.")
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 20, shadow: .soft, stroke: Color.appPrimary.opacity(0.2))
        }
        .buttonStyle(.plain)
    }

    private var sealSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose up to three findings to carry into tomorrow’s Morning Brief.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                    if appState.sealCandidateTitles.isEmpty {
                        Text("Complete an atlas run, lattice story, or journal note first.")
                            .font(.footnote)
                            .foregroundStyle(Color.appTextSecondary)
                    } else {
                        ForEach(appState.sealCandidateTitles, id: \.self) { title in
                            Button {
                                toggleCarry(title)
                            } label: {
                                HStack {
                                    Image(systemName: selectedCarry.contains(title) ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selectedCarry.contains(title) ? Color.appAccent : Color.appTextSecondary)
                                    Text(title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Color.appTextPrimary)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(12)
                                .appDepthSurface(cornerRadius: 12, shadow: .soft)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Text("Residue note")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(.uppercase)
                    TextField("What still pulls at you tonight?", text: $residueDraft, axis: .vertical)
                        .lineLimit(3...5)
                        .padding(12)
                        .appDepthSurface(cornerRadius: 12, shadow: .soft)
                    Button {
                        appState.sealFieldDay(
                            carriedTitles: Array(selectedCarry),
                            residueNote: residueDraft
                        )
                        showSealSheet = false
                        residueDraft = ""
                    } label: {
                        Text(appState.isTodaySealed ? "Update today’s seal" : "Seal day")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 48)
                            .foregroundStyle(Color.appTextPrimary)
                            .appDepthSurface(cornerRadius: 14, shadow: .soft, stroke: Color.appAccent.opacity(0.45))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
            .appDepthScrollBackdrop()
            .navigationTitle("Field Day Seal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { showSealSheet = false }
                }
            }
        }
    }

    private func toggleCarry(_ title: String) {
        if selectedCarry.contains(title) {
            selectedCarry.remove(title)
        } else if selectedCarry.count < 3 {
            selectedCarry.insert(title)
        }
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
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 8)
            .appDepthSurface(cornerRadius: 20, shadow: .soft, stroke: tint.opacity(0.28))
        }
        .buttonStyle(.plain)
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
                    Text("Cadence ring")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("\(Int((ratio * 100).rounded()))% · \(active) rhythms")
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
    }

    private var iconShortcutsRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Field jumps")
                .font(.caption.weight(.heavy))
                .foregroundStyle(Color.appTextSecondary)
                .textCase(.uppercase)
            HStack(spacing: 10) {
                iconJump(icon: "map.fill", tab: .explore)
                iconJump(icon: "archivebox.fill", tab: .collections)
                iconJump(icon: "waveform.path.ecg", tab: .journeys)
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
                    .fill(Color.appPrimary.opacity(0.22))
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
                    Text("Next drill")
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
    }

    private var nextSuggestionVisual: (title: String, symbol: String, tab: MainTab) {
        if appState.needsMorningBrief {
            return ("Finish Morning Brief", "sunrise.fill", .home)
        }
        if !appState.isTodaySealed, Calendar.current.component(.hour, from: Date()) >= 17 {
            return ("Open Field Day Seal", "seal.fill", .home)
        }
        if appState.cartographerStagesCleared < 5 {
            return ("Atlas route", "map.fill", .explore)
        }
        if appState.silhouetteStagesCleared < 3 {
            return ("Story lattice", "square.grid.3x3.fill", .explore)
        }
        return ("Log a drift pull", "waveform.path.ecg", .journeys)
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
                    Text("Latest field mark · \(entry.starsEarned) pts")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appDepthSurface(cornerRadius: 20, shadow: .soft)
        }
        .buttonStyle(.plain)
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
                    Text("Field notes")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    if let snippet = appState.journalEntries.first?.body.split(separator: "\n").first {
                        Text(String(snippet))
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)
                    } else {
                        Text("Capture residue before you seal")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.appTextSecondary)
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
