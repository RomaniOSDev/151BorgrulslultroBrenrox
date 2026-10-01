//
//  JourneysView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

private enum SessionFilter: String, CaseIterable {
    case all = "All"
    case thisWeek = "This week"
}

struct JourneysView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @State private var sessionFilter: SessionFilter = .all

    private var filteredSessions: [LoggedSessionEntry] {
        let log = appState.sessionLog
        guard sessionFilter == .thisWeek else { return log }
        let week = TravelAppState.weekIdentifier(for: Date())
        return log.filter { TravelAppState.weekIdentifier(for: $0.completedAt) == week }
    }

    private var packingPackedCount: Int {
        appState.packingItems.filter(\.isPacked).count
    }

    private var packingTotal: Int {
        max(1, appState.packingItems.count)
    }

    private var packingProgress: Double {
        Double(packingPackedCount) / Double(packingTotal)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroHeader

                    driftRadarCard

                    driftTagRow

                    weeklyTrioCard

                    quickActionsRow

                    fieldJournalCard

                    sessionsSection

                    packingSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .appDepthScrollBackdrop()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
    }

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Drift radar")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("Tag what pulls you off fieldwork. Peak hours feed a quieter window suggestion for tomorrow’s Brief.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextPrimary.opacity(0.92))
                .lineLimit(5)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                statTile(
                    title: "Seal streak",
                    value: "\(appState.sealStreak)d",
                    icon: "seal.fill",
                    tint: Color.appAccent
                )
                statTile(
                    title: "Drifts",
                    value: "\(appState.driftEvents.count)",
                    icon: "waveform.path.ecg",
                    tint: Color.appPrimary
                )
                statTile(
                    title: "Sessions",
                    value: "\(appState.sessionLog.count)",
                    icon: "clock.arrow.circlepath",
                    tint: Color.appPrimary.opacity(0.9)
                )
                statTile(
                    title: "Notes",
                    value: "\(appState.journalEntries.count)",
                    icon: "square.and.pencil",
                    tint: Color.appAccent.opacity(0.95)
                )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 22, shadow: .soft)
    }

    private var driftRadarCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Quiet window", systemImage: "moon.stars.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
            Text(appState.quietWindowLabel)
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            if let seal = appState.latestFieldSeal {
                Divider().opacity(0.3)
                Text("Last seal · day \(seal.dayId)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Color.appTextSecondary)
                    .textCase(.uppercase)
                if !seal.carriedTitles.isEmpty {
                    Text(seal.carriedTitles.joined(separator: " · "))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(3)
                }
                if !seal.residueNote.isEmpty {
                    Text(seal.residueNote)
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(3)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft, stroke: Color.appAccent.opacity(0.25))
    }

    private var driftTagRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Log a drift")
                .font(.caption.weight(.heavy))
                .foregroundStyle(Color.appTextSecondary)
                .textCase(.uppercase)
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                ForEach(DriftKind.allCases) { kind in
                    Button {
                        appState.logDrift(kind: kind)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: kind.symbol)
                            Text(kind.title)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .appDepthSurface(cornerRadius: 12, shadow: .soft, stroke: Color.appPrimary.opacity(0.2))
                    }
                    .buttonStyle(.plain)
                }
            }
            if !appState.driftEvents.isEmpty {
                ForEach(appState.driftEvents.prefix(4)) { event in
                    HStack {
                        Image(systemName: event.kind.symbol)
                            .foregroundStyle(Color.appAccent)
                        Text(event.kind.title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.appTextPrimary)
                        Spacer()
                        Text(event.createdAt.formatted(date: .omitted, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }

    private func statTile(title: String, value: String, icon: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.appBackground.opacity(0.35))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary.opacity(0.85))
                    .lineLimit(1)
                Text(value)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .appDepthSurface(cornerRadius: 14, shadow: .none)
    }

    private var weeklyTrioCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Weekly trio path")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                Spacer()
                if appState.routeWkStarsClaimed {
                    Label("Bonus", systemImage: "checkmark.seal.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appAccent)
                }
            }

            Text("Complete one atlas run, one lattice story, and one habit rhythm this week to earn a three-star burst.")
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(4)
                .minimumScaleFactor(0.75)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 0) {
                trioStep(
                    title: "Atlas",
                    subtitle: "Cartographer",
                    systemImage: "map.fill",
                    done: appState.routeWkCarto
                )
                trioConnector(filled: appState.routeWkCarto)
                trioStep(
                    title: "Lattice",
                    subtitle: "Silhouette",
                    systemImage: "square.grid.3x3.fill",
                    done: appState.routeWkSil
                )
                trioConnector(filled: appState.routeWkSil)
                trioStep(
                    title: "Rhythm",
                    subtitle: "Habits",
                    systemImage: "waveform.path",
                    done: appState.routeWkHabit
                )
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 6) {
                ProgressView(value: appState.routeOfWeekProgress)
                    .tint(Color.appPrimary)
                Text("\(appState.routeOfWeekCompletedSteps) of 3 lanes cleared")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft, stroke: Color.appPrimary.opacity(0.16))
    }

    private func trioStep(title: String, subtitle: String, systemImage: String, done: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(done ? Color.appPrimary.opacity(0.35) : Color.appSurface.opacity(0.9))
                    .frame(width: 48, height: 48)
                Image(systemName: done ? "checkmark.circle.fill" : systemImage)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(done ? Color.appPrimary : Color.appTextSecondary)
            }
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(1)
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    private func trioConnector(filled: Bool) -> some View {
        Rectangle()
            .fill(filled ? Color.appPrimary.opacity(0.55) : Color.appTextSecondary.opacity(0.2))
            .frame(height: 3)
            .padding(.bottom, 36)
            .frame(maxWidth: 28)
    }

    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            Button {
                tabCoordinator.requestTab(.explore)
            } label: {
                quickActionLabel(title: "Explore", subtitle: "Activities", systemImage: "globe.europe.africa.fill")
            }
            .buttonStyle(.plain)

            Button {
                tabCoordinator.requestTab(.collections)
            } label: {
                quickActionLabel(title: "Decks", subtitle: "Collections", systemImage: "square.grid.2x2.fill")
            }
            .buttonStyle(.plain)
        }
    }

    private func quickActionLabel(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.appPrimary.opacity(0.22)))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.appPrimary.opacity(0.85))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 16, shadow: .soft)
    }

    private var fieldJournalCard: some View {
        NavigationLink {
            FieldJournalView()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.appPrimary.opacity(0.28))
                        .frame(width: 52, height: 52)
                        .overlay {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color.appAccent)
                        }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Field journal")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(Color.appTextPrimary)
                        Text("Textures, overheard lines, and detours worth a second walk.")
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appTextSecondary)
                }

                if let preview = appState.journalEntries.first?.body {
                    Text(preview)
                        .font(.footnote)
                        .foregroundStyle(Color.appTextPrimary.opacity(0.9))
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.appBackground.opacity(0.45))
                        )
                } else {
                    Text("No entries yet — tap to start your first note.")
                        .font(.footnote)
                        .foregroundStyle(Color.appTextSecondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)
            .appDepthSurface(cornerRadius: 18, shadow: .soft)
        }
        .buttonStyle(.plain)
    }

    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent sessions")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("Newest first")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color.appTextSecondary)
                }
                Spacer(minLength: 8)
            }

            Picker("Filter", selection: $sessionFilter) {
                ForEach(SessionFilter.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            if filteredSessions.isEmpty {
                Text(emptySessionsMessage)
                    .font(.footnote)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(5)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(filteredSessions.enumerated()), id: \.element.id) { index, entry in
                        sessionRow(entry)
                        if index < filteredSessions.count - 1 {
                            Divider()
                                .overlay(Color.appTextSecondary.opacity(0.15))
                                .padding(.leading, 58)
                        }
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }

    private var emptySessionsMessage: String {
        switch sessionFilter {
        case .all:
            return "No journeys recorded yet. Complete an activity to populate this list."
        case .thisWeek:
            return "Nothing logged this calendar week yet. Finish a session and it will appear here."
        }
    }

    private var packingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Packing checklist")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("\(packingPackedCount) of \(appState.packingItems.count) packed")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.appTextSecondary)
                }
                Spacer()
                HStack(spacing: 8) {
                    Button("Clear") {
                        appState.setAllPackingItemsPacked(false)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.appBackground.opacity(0.5))
                    )
                    .accessibilityLabel(Text("Mark all packing items as not packed"))

                    Button("All packed") {
                        appState.setAllPackingItemsPacked(true)
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.appPrimary.opacity(0.45))
                    )
                    .accessibilityLabel(Text("Mark all packing items as packed"))
                }
            }

            ProgressView(value: packingProgress)
                .tint(Color.appAccent)

            ForEach(appState.packingItems) { row in
                Toggle(isOn: packingBinding(for: row.id)) {
                    Text(packingTitle(for: row.id))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                }
                .tint(Color.appPrimary)
                .padding(.vertical, 6)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 18, shadow: .soft)
    }

    private func sessionRow(_ entry: LoggedSessionEntry) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: sessionIcon(entry.activityKind))
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(sessionTint(entry.activityKind))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(sessionTint(entry.activityKind).opacity(0.18))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.detailTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                HStack(spacing: 6) {
                    Text(sessionKindLabel(entry.activityKind))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.appTextSecondary)
                    Text("·")
                        .foregroundStyle(Color.appTextSecondary.opacity(0.6))
                    Text(entry.completedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 2) {
                Text("+\(entry.starsEarned)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.appAccent)
                Text("stars")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("\(entry.starsEarned) stars earned"))
        }
        .padding(.vertical, 10)
    }

    private func sessionIcon(_ kind: String) -> String {
        switch kind {
        case "cartographer": return "map.fill"
        case "silhouette": return "square.grid.3x3.fill"
        case "habit": return "waveform.path"
        case "weekly_micro": return "sparkles"
        case "route_week": return "point.topleft.down.curvedto.point.bottomright.up"
        default: return "circle.grid.cross.fill"
        }
    }

    private func sessionTint(_ kind: String) -> Color {
        switch kind {
        case "cartographer": return Color.appPrimary
        case "silhouette": return Color.appAccent
        case "habit": return Color.appPrimary.opacity(0.85)
        case "weekly_micro": return Color.appAccent.opacity(0.9)
        case "route_week": return Color.appAccent
        default: return Color.appTextSecondary
        }
    }

    private func sessionKindLabel(_ kind: String) -> String {
        switch kind {
        case "cartographer": return "Atlas"
        case "silhouette": return "Lattice"
        case "habit": return "Rhythm"
        case "weekly_micro": return "Reflections"
        case "route_week": return "Weekly trio"
        default:
            return kind.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    private func packingTitle(for id: UUID) -> String {
        appState.packingItems.first(where: { $0.id == id })?.title ?? ""
    }

    private func packingBinding(for id: UUID) -> Binding<Bool> {
        Binding(
            get: { appState.packingItems.first(where: { $0.id == id })?.isPacked ?? false },
            set: { newValue in
                guard let index = appState.packingItems.firstIndex(where: { $0.id == id }) else { return }
                var copy = appState.packingItems[index]
                copy.isPacked = newValue
                appState.packingItems[index] = copy
            }
        )
    }
}
