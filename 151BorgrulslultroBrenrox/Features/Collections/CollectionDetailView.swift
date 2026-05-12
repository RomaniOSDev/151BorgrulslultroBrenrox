//
//  CollectionDetailView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct CollectionDetailView: View {
    @EnvironmentObject private var appState: TravelAppState
    let deckIndex: Int

    private var deckTitle: String {
        switch deckIndex {
        case 0: return "Heritage weave"
        case 1: return "Spoken ember"
        case 2: return "Table cartography"
        default: return "Deck"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(deckTitle)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Text("Short readings you can mark as viewed to track your cultural pass. Cards are ordered from dye rhythm to etiquette edges—skim titles first if time is short, then return for the prose.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(8)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)

                Text(CultureTipsProvider.ambientLine(seed: deckIndex * 31 + appState.viewedInsightCardKeys.count))
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary.opacity(0.95))
                    .lineLimit(5)
                    .minimumScaleFactor(0.7)

                let cards = CollectionCatalog.cards(for: deckIndex)
                ForEach(cards) { card in
                    insightCard(card)
                }
            }
            .padding(16)
        }
        .appDepthScrollBackdrop()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func insightCard(_ card: CollectionInsightCard) -> some View {
        let viewed = appState.isInsightViewed(deck: deckIndex, cardId: card.id)
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(card.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Spacer()
                if viewed {
                    Label("Viewed", systemImage: "eye.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appAccent)
                }
            }
            Text(card.prose)
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(24)
                .minimumScaleFactor(0.7)

            if viewed == false {
                Button {
                    appState.markInsightViewed(deck: deckIndex, cardId: card.id)
                } label: {
                    Text("Mark as viewed")
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .buttonStyle(AppSecondaryButtonStyle())
            }
        }
        .padding(16)
        .appDepthSurface(cornerRadius: 18, shadow: .none)
    }
}
