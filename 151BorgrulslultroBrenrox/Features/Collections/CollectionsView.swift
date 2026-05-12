//
//  CollectionsView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct CollectionsView: View {
    @EnvironmentObject private var appState: TravelAppState

    private let decks: [(title: String, detail: String, index: Int)] = [
        (
            "Heritage weave",
            "Textile pigments, loom cadence, and visible repair ethics. Each card is a micro-essay you can mark viewed—stack them like swatches before planning a longer itinerary thread.",
            0
        ),
        (
            "Spoken ember",
            "Call-and-response cadence, lantern grammar, and seasonal masks. Use these notes before recording folklore habits so your weekly log carries sharper nouns.",
            1
        ),
        (
            "Table cartography",
            "Fermentation clocks, spice debts, and shared cloth etiquette. Pair readings with culinary habit targets to keep flavors tied to lived schedules, not generic checklists.",
            2
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    Text("Curated decks")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("Unlock additional decks by gathering travel stars across activities. Each deck opens into a scroll of short essays—read slowly, then mark cards viewed to build a personal index.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(8)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)

                    ForEach(decks, id: \.index) { deck in
                        let unlocked = appState.isCollectionUnlocked(index: deck.index)
                        Group {
                            if unlocked {
                                NavigationLink {
                                    CollectionDetailView(deckIndex: deck.index)
                                } label: {
                                    collectionCard(
                                        title: deck.title,
                                        detail: deck.detail,
                                        unlocked: true,
                                        showBrowseHint: true
                                    )
                                }
                                .buttonStyle(.plain)
                            } else {
                                collectionCard(
                                    title: deck.title,
                                    detail: deck.detail,
                                    unlocked: false,
                                    showBrowseHint: false
                                )
                            }
                        }
                    }
            }
            .padding(16)
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

    private func collectionCard(title: String, detail: String, unlocked: Bool, showBrowseHint: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Image(systemName: unlocked ? "lock.open.fill" : "lock.fill")
                    .foregroundStyle(unlocked ? Color.appAccent : Color.appTextSecondary)
                    .frame(width: 44, height: 44)
            }
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(10)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
            if unlocked {
                Text(showBrowseHint ? "Open the deck to read short cultural notes and mark them viewed." : "Ready to pair with any route you chart next.")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
            } else {
                Text("Earn more stars through activities to open this deck.")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(16)
        .appDepthSurface(cornerRadius: 18, shadow: unlocked ? .soft : .none)
    }
}
