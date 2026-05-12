//
//  ActivitySelectionView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

private enum ExploreTheme: String, CaseIterable, Identifiable {
    case artisan
    case folklore
    case culinary

    var id: String { rawValue }

    var title: String {
        switch self {
        case .artisan: return "Artisan Crafts"
        case .folklore: return "Folklores"
        case .culinary: return "Culinary Heritage"
        }
    }
}

private struct ActivityCardModel: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
}

struct ActivitySelectionView: View {
    @EnvironmentObject private var appState: TravelAppState
    @Namespace private var cardSpace
    @State private var theme: ExploreTheme = .artisan

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WeeklyProgressSection()

                HStack(alignment: .center, spacing: 12) {
                    Text("Studios")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Spacer(minLength: 0)
                    HStack(spacing: 10) {
                        Image(systemName: "paintbrush.pointed.fill")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.appPrimary)
                        Image(systemName: "theatermasks.fill")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.appAccent)
                        Image(systemName: "fork.knife")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.appPrimary)
                    }
                    .opacity(0.85)
                }

                Text("Pick a lane, open a studio.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)

                laneNotesCard

                ScrollView(.horizontal, showsIndicators: false) {
                    Picker("", selection: $theme) {
                        ForEach(ExploreTheme.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(minWidth: 340)
                }

                LazyVStack(spacing: 14) {
                    ForEach(cards(for: theme)) { card in
                        NavigationLink {
                            destination(for: card.id)
                        } label: {
                            activityCard(card)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
        .appDepthScrollBackdrop()
    }

    private func cards(for theme: ExploreTheme) -> [ActivityCardModel] {
        switch theme {
        case .artisan:
            return [
                ActivityCardModel(
                    id: "cartographer",
                    title: "Culture Cartographer",
                    subtitle: "Atlas routes · patient drags",
                    systemImage: "point.topleft.down.curvedto.point.bottomright.up"
                ),
                ActivityCardModel(
                    id: "silhouette",
                    title: "Story Silhouette",
                    subtitle: "Lattice tiles · careful lifts",
                    systemImage: "square.grid.3x3.fill"
                ),
                ActivityCardModel(
                    id: "habit",
                    title: "Habit-Hub Explorer",
                    subtitle: "Weekly ritual ring",
                    systemImage: "chart.pie.fill"
                )
            ]
        case .folklore:
            return [
                ActivityCardModel(
                    id: "cartographer",
                    title: "Culture Cartographer",
                    subtitle: "Paths · chorus · night arcs",
                    systemImage: "point.topleft.down.curvedto.point.bottomright.up"
                ),
                ActivityCardModel(
                    id: "silhouette",
                    title: "Story Silhouette",
                    subtitle: "Masks · lattice shadows",
                    systemImage: "theatermasks.fill"
                ),
                ActivityCardModel(
                    id: "habit",
                    title: "Habit-Hub Explorer",
                    subtitle: "Refrain & gesture beats",
                    systemImage: "chart.pie.fill"
                )
            ]
        case .culinary:
            return [
                ActivityCardModel(
                    id: "cartographer",
                    title: "Culture Cartographer",
                    subtitle: "Spice docks · steam lanes",
                    systemImage: "point.topleft.down.curvedto.point.bottomright.up"
                ),
                ActivityCardModel(
                    id: "silhouette",
                    title: "Story Silhouette",
                    subtitle: "Tasting lattice",
                    systemImage: "fork.knife"
                ),
                ActivityCardModel(
                    id: "habit",
                    title: "Habit-Hub Explorer",
                    subtitle: "Market walks & bites",
                    systemImage: "chart.pie.fill"
                )
            ]
        }
    }

    @ViewBuilder
    private func destination(for id: String) -> some View {
        switch id {
        case "cartographer":
            CartographerStageListView()
        case "silhouette":
            SilhouettePuzzleListView()
        case "habit":
            HabitHubExplorerView()
        default:
            EmptyView()
        }
    }

    private func activityCard(_ card: ActivityCardModel) -> some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.appPrimary.opacity(0.35), Color.appAccent.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                Image(systemName: card.systemImage)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.appAccent)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Text(card.subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right.circle.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.appPrimary.opacity(0.55))
        }
        .padding(16)
        .appDepthSurface(cornerRadius: 18, shadow: .lifted)
        .matchedGeometryEffect(id: "\(theme.id)-\(card.id)", in: cardSpace)
    }

    private var laneNotesCard: some View {
        let seed = appState.totalStars + appState.mappedLocations + appState.journalEntries.count
        let laneIcon: String = {
            switch theme {
            case .artisan: return "hammer.fill"
            case .folklore: return "moon.stars.fill"
            case .culinary: return "fork.knife.circle.fill"
            }
        }()
        return HStack(alignment: .top, spacing: 12) {
            Image(systemName: laneIcon)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 48, height: 48)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.appPrimary.opacity(0.2)))
            VStack(alignment: .leading, spacing: 6) {
                Text("Lane note")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(Color.appTextSecondary)
                    .textCase(.uppercase)
                Text(CultureTipsProvider.laneDeepDive(lane: theme.rawValue, seed: seed))
                    .font(.caption)
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.75)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appDepthSurface(cornerRadius: 16, shadow: .soft)
    }
}
