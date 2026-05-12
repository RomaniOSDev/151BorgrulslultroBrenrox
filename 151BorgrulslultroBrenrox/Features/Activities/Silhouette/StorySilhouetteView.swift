//
//  StorySilhouetteView.swift
//  151BorgrulslultroBrenrox
//

import SwiftUI

struct StorySilhouetteView: View {
    @EnvironmentObject private var appState: TravelAppState
    @EnvironmentObject private var tabCoordinator: TabCoordinator
    @Environment(\.dismiss) private var dismiss

    @StateObject private var model: StorySilhouetteViewModel
    @State private var outcome: ActivityOutcome?

    init(puzzleIndex: Int) {
        _model = StateObject(wrappedValue: StorySilhouetteViewModel(puzzleIndex: puzzleIndex))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Story Silhouette")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("Tiles lift with a spring snap. Aim for the narrative lattice only.")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)

                    silhouetteGrid

                    HStack {
                        Label("Stray taps", systemImage: "hand.tap")
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Text("\(model.strayTaps)")
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    HStack {
                        Label("Lattice tiles", systemImage: "square.grid.3x3")
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Text("\(model.revealed.intersection(model.storyIndices).count)/\(model.storyIndices.count)")
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                .padding(16)
            }
            .appDepthScrollBackdrop()

            if let outcome {
                ActivityResultView(
                    outcome: outcome,
                    onReplay: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                            self.outcome = nil
                        }
                        model.reset()
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
        .onChange(of: model.finished) { done in
            guard done, outcome == nil else { return }
            let stars = model.starsEarned()
            appState.registerSilhouetteCompletion(puzzleIndex: model.puzzleIndex, stars: stars)
            outcome = ActivityOutcome(
                id: UUID().uuidString,
                headline: "Narrative lattice complete",
                detail: "Silhouette tiles settled with deliberate rhythm.",
                stars: stars,
                preview: "Weekly habit hub can now echo this cadence for tangible rituals.",
                cultureTip: CultureTipsProvider.tip(for: .silhouette, variant: model.puzzleIndex)
            )
        }
        .animation(.easeInOut(duration: 0.35), value: outcome != nil)
    }

    private var silhouetteGrid: some View {
        let spacing: CGFloat = 6
        return VStack(spacing: spacing) {
            ForEach(0..<model.rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<model.columns, id: \.self) { column in
                        let index = row * model.columns + column
                        tile(for: index)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.appSurface.opacity(0.65))
        )
    }

    private func tile(for index: Int) -> some View {
        let isRevealed = model.revealed.contains(index)
        let isStory = model.storyIndices.contains(index)
        return Button {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.68)) {
                model.tapTile(flatIndex: index)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(tileFill(isRevealed: isRevealed, isStory: isStory))
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isRevealed && isStory ? Color.appAccent : Color.clear, lineWidth: 2)
                if isRevealed && isStory {
                    Capsule()
                        .fill(Color.appTextPrimary.opacity(0.35))
                        .frame(height: 5)
                        .padding(.horizontal, 8)
                }
            }
            .frame(minWidth: 44, minHeight: 44)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(isRevealed ? "Revealed tile" : "Hidden tile"))
    }

    private func tileFill(isRevealed: Bool, isStory: Bool) -> Color {
        if isRevealed {
            return isStory ? Color.appPrimary.opacity(0.45) : Color.appSurface.opacity(0.35)
        }
        return Color.appBackground.opacity(0.55)
    }
}
